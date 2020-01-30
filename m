Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1E14DC5C
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 14:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgA3Nzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 08:55:39 -0500
Received: from mail-40135.protonmail.ch ([185.70.40.135]:25815 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgA3Nzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 08:55:38 -0500
Date:   Thu, 30 Jan 2020 13:55:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1580392535;
        bh=qDxsIQMAfuuQ++x4ukJekyrx9S+ZKzgz5wPdBOs7E38=;
        h=Date:To:From:Cc:Reply-To:Subject:Feedback-ID:From;
        b=jwgYHW1hwBugCNcb8ZG6dbURJBxAc9Xy5Trt6ufi9xXS2bOpclfM8h0RH9sfl3K8F
         j8u74H5PQ0HmBLC5eONqu2xxYU98nNyYtcPS2uvxMBSvYYSOBP3nNWwspgHH3v8q6c
         2dSVIO8yf4UbzfFNiIM2qMBpqArsoxxtdE9BHX3M=
To:     Netdev <netdev@vger.kernel.org>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: [RFC] tcp: syncookies: Interesting serious errors when generating and verification cookies
Message-ID: <MUBNBny50CpQ5J-18Cx99emdQLBJsj6NiZUx_YT2wTBKSWmpTt1Ly67TGbllsxL-JVA2fCESTWEk72hrLWBukVvZcN2-3DidrDdrLRN9g9M=@protonmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HK_RANDOM_REPLYTO shortcircuit=no autolearn=no autolearn_force=no
        version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following are the two core functions of current syncookies calculation gene=
rating and verification.

static __u32 secure_tcp_syn_cookie(__be32 saddr, __be32 daddr, __be16 sport=
,
=09=09=09=09   __be16 dport, __u32 sseq, __u32 data)
{
=09/*
=09 * Compute the secure sequence number.
=09 * The output should be:
=09 *   HASH(sec1,saddr,sport,daddr,dport,sec1) + sseq + (count * 2^24)
=09 *      + (HASH(sec2,saddr,sport,daddr,dport,count,sec2) % 2^24).
=09 * Where sseq is their sequence number and count increases every
=09 * minute by 1.
=09 * As an extra hack, we add a small "data" value that encodes the
=09 * MSS into the second hash value.
=09 */
=09u32 count =3D tcp_cookie_time();
=09return (cookie_hash(saddr, daddr, sport, dport, 0, 0) +
=09=09sseq + (count << COOKIEBITS) +
=09=09((cookie_hash(saddr, daddr, sport, dport, count, 1) + data)
=09=09 & COOKIEMASK));
}

static __u32 check_tcp_syn_cookie(__u32 cookie, __be32 saddr, __be32 daddr,
=09=09=09=09  __be16 sport, __be16 dport, __u32 sseq)
{
=09u32 diff, count =3D tcp_cookie_time();

=09/* Strip away the layers from the cookie */
=09cookie -=3D cookie_hash(saddr, daddr, sport, dport, 0, 0) + sseq;

=09/* Cookie is now reduced to (count * 2^24) ^ (hash % 2^24) */
=09diff =3D (count - (cookie >> COOKIEBITS)) & ((__u32) -1 >> COOKIEBITS);
=09if (diff >=3D MAX_SYNCOOKIE_AGE)
=09=09return (__u32)-1;

=09return (cookie -
=09=09cookie_hash(saddr, daddr, sport, dport, count - diff, 1))
=09=09& COOKIEMASK;=09/* Leaving the data behind */
}

Can you find the problem?

Generate formula is:

cookie =3D HASH(sec1,saddr,sport,daddr,dport,sec1) + sseq + (count * 2^24)
             + ((HASH(sec2,saddr,sport,daddr,dport,count,sec2) + data) % 2^=
24)

Verification formula is:

data =3D (cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - HASH(se=
c2,saddr,sport,daddr,dport,count,sec2)) % 2^24

I don't know if the final & is a modulo or an AND operation, but the result=
 is the same.

Now, I think anyone will understand that the above calculation is wrong.

---------------------------------------------------------------

We know that the last % 2^24 is to remove the upper 8 bits of counte * 2^24=
.

If we do not perform the final modulo, then the formula is:

(count * 2^24) + data =3D cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) =
- sseq - HASH(sec2,saddr,sport,daddr,dport,count,sec2)

The conversion into a generating formula is:

cookie =3D HASH(sec1,saddr,sport,daddr,dport,sec1) + sseq + (count * 2^24) =
+ HASH(sec2,saddr,sport,daddr,dport,count,sec2) + data

Compared with the real generation formula:

cookie =3D HASH(sec1,saddr,sport,daddr,dport,sec1) + sseq + (count * 2^24) =
+ ((HASH(sec2,saddr,sport,daddr,dport,count,sec2) + data) % 2^24)

These two formulas are completely different!

So the final calculated (count * 2^24) + data is absolutely wrong.

The correct verification calculation should be:

data =3D (cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - (HASH(s=
ec2,saddr,sport,daddr,dport,count,sec2) % 2^24)) % 2^24

------------------------------------------------------------------

The most interesting place came, the result of the final data turned out to=
 be correct.

((count * 2^24) + data) % 2^24 is correct!

Why?

correct verification calculation:

data =3D (cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - (HASH(s=
ec2,saddr,sport,daddr,dport,count,sec2) % 2^24)) % 2^24

current verification formula:

data =3D (cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - HASH(se=
c2,saddr,sport,daddr,dport,count,sec2)) % 2^24

What do you find in comparison? The difference is that before subtracting H=
ASH(sec2, saddr, sport, daddr, dport, count, sec2) we have to take the modu=
lus first.

We know that modulo a % 2^n is equivalent to a & (2^n - 1). So the correct =
calculation is to subtract the lower 24 bits of HASH2. The current practice=
 is to subtract the entire 32 bits of HASH2.

The error is only in the high bit and has no effect on the low bit.

data is in low bit!

Amazing coincidence reached the right result with the wrong implementation.

Therefore, this wrong implementation has been used for many years without a=
ny problems.

-------------------------------------------------------------------------

In the end I raised this RFC to ask, should we fix this implementation?

-------------------------------------------------------------------------

Maybe what I said above is a bit difficult to understand. I drew some pictu=
res to help you understand.

Define HASH(sec1,saddr,sport,daddr,dport,sec1) as HASH1.

Define HASH(sec2,saddr,sport,daddr,dport,count,sec2) as HASH2.

HASH2 + data is expressed as:
+----------------------------------------------+
|                 32 bit HASH2                 |
+----------------------------------------------+
                                        add
                                  +------------+
                                  | 2 bit data |
                                  +------------+
                      result
+----------------------------------------------+
|                                              |
|                 32 bit HASH2       +---------+
|                                    |  data   |
+------------------------------------+---------+

The process of generating cookies can be expressed as:
+----------------------------------------------+
|                 32 bit HASH1                 |
+----------------------------------------------+
                      add
+----------------------------------------------+
|                 32 bit sseq                  |
+----------------------------------------------+
      add
+-------------+
| 8 bit count |
+-------------+               add
               +-------------------------------+
               |                               |
               |    low 24 bit HASH2 +---------+
               |                     |  data   |
               +---------------------+---------+
                  result
+----------------------------------------------+
|                 32 bit cookie                |
+----------------------------------------------+

The process of restoring data can be expressed as:
+----------------------------------------------+
|                 32 bit cookie                |
+----------------------------------------------+
                   subtract
+----------------------------------------------+
|                 32 bit HASH1                 |
+----------------------------------------------+
                   subtract
+----------------------------------------------+
|                 32 bit sseq                  |
+----------------------------------------------+
                    result
+-------------+--------------------------------+
|             |                                |
| 8 bit count |    low 24 bit HASH2  +---------+
|             |                      |  data   |
+-------------+----------------------+---------+

What to do next?

The correct calculation is:
+-------------+--------------------------------+
|             |                                |
| 8 bit count |    low 24 bit HASH2  +---------+
|             |                      |  data   |
+-------------+----------------------+---------+
                            subtract
              +--------------------------------+
              |        low 24bit HASH2         |
              +--------------------------------+
                    result
+-------------+----------------------+---------+
| 8 bit count |                      |  data   |
+-------------+----------------------+---------+
             Reserved lower 24 bits
              +----------------------+---------+
              |                      |  data   |
              +----------------------+---------+

The current calculation is:
+-------------+--------------------------------+
|             |                                |
| 8 bit count |    low 24 bit HASH2  +---------+
|             |                      |  data   |
+-------------+----------------------+---------+
                    subtract
+-------------+--------------------------------+
| high 8 bit  |           low 24 bit           |
|    HASH2    |              HASH2             |
+-------------+--------------------------------++
                     result
+-------------+----------------------+---------+
|    wrong    |                      | correct |
| 8 bit count |                      |  data   |
+-------------+----------------------+---------+
             Reserved lower 24 bits
              +----------------------+---------+
              |                      |  data   |
              +----------------------+---------+
