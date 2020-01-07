Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B8B131CCC
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 01:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgAGAiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 19:38:00 -0500
Received: from mail-40135.protonmail.ch ([185.70.40.135]:28699 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgAGAiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 19:38:00 -0500
Date:   Tue, 07 Jan 2020 00:37:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578357476;
        bh=DoEzISZfAUvKRmOU+Fq9jpnaryuQ7BvqJN1Fe8PbrgI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=ky7LmuCTGRPHGZ0NPC5L8wV9DPoPUxdD3c1jKvSPQA8UZmIR7YHIWxET6rEzizWR7
         MW6HLPqgpE1vQ9Q+JKedOIqBvRd+SLbVaDbWtuuyiE/jDx9+uvc2V8GDQzC8JQqLY9
         ku2uFpkYcJtf569pT3nuHHlZnaa7soM8X09Akj8w=
To:     Stephen Hemminger <stephen@networkplumber.org>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] fragment: Improved handling of incorrect IP fragments
Message-ID: <Kzdjj3swtF0OuPXyJNmMt2qALVQ3Hob3fvSXhMkyqTbp9qUer0B1s_Lj1uYJJV4hEXp2v1M6bJ0XCS3zbYWOrZrzyydP-Bb4P15pDPFj0FY=@protonmail.com>
In-Reply-To: <20200106160635.2550c92f@hermes.lan>
References: <u0QFePiYSfxBeUsNVFRhPjsGViwg-pXLIApJaVLdUICuvLTQg5y5-rdNhh9lPcDsyO24c7wXxy5m6b6dK0aB6kqR0ypk8X9ekiLe3NQ3ICY=@protonmail.com>
 <20200102112731.299b5fe4@hermes.lan>
 <BRNuMFiJpql6kgRrEdMdQfo3cypcBpqGRtfWvbW8QFsv2MSUj_fUV-s8Fx-xopJ8kvR3ZMJM0tck6FYxm8S0EcpZngEzrfFg5w22Qo8asEQ=@protonmail.com>
 <20200106160635.2550c92f@hermes.lan>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> With current (correct) Linux kernel code this gets reassembled and droppe=
d.
> As seen in dmesg log and statistics.
>
> With your Ipv4 patch the oversize packet gets passed on up the stack.
>
> Testing this stuff is hard, it requires packet hacker tools.

I know what you mean. What you are talking about is a "ping of death" attac=
k. The use of fragments to construct packets longer than 65535 made the sys=
tem buffer overflow and crash.

This situation has been considered in my code. In the original logic of IPv=
6, the judgment of data packets exceeding 65535 is duplicated, and the judg=
ment in IPv4 is too late.

I have improved this situation, you can see my explanation of the patch at =
the beginning.

> In both ip6_frag_queue and ip6_frag_reasm, it is checked whether it is an
> Oversized IPv6 packet, which is duplicated. The original code logic will
> only be processed in ip6_frag_queue. The code of ip6_frag_reasm will not
> be executed. Now change it to only process in ip6_frag_queue and output
> the prompt information.

> I also made similar changes in IPv4 fragmentation processing.
>
> It is not good to use 65535 values directly,
> I added the IPV4_MAX_TOT_LEN macro.
>
> The oversized check in IPv4 fragment processing is in the ip_frag_reasm
> of the reassembly fragment. This is too late. The incorrect IP fragment
> has been inserted into the fragment queue. I modified it in ip_frag_queue=
.
> I changed the original net_info_ratelimited to net_dbg_ratelimited to mak=
e
> the debugging information more controllable.


@@ -300,6 +300,12 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buf=
f *skb)
 =09end =3D offset + skb->len - skb_network_offset(skb) - ihl;
 =09err =3D -EINVAL;

+=09if ((unsigned int)end + ihl > IPV4_MAX_TOT_LEN) {
+=09=09net_dbg_ratelimited("ip_frag_queue: Oversized IP packet from %pI4, e=
nd =3D %d\n",
+=09=09=09=09    &qp->q.key.v4.saddr, end);
+=09=09goto discard_qp;
+=09}
+

@@ -121,11 +121,10 @@ static int ip6_frag_queue(struct frag_queue *fq, stru=
ct sk_buff *skb,
 =09=09=09((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));

 =09if ((unsigned int)end > IPV6_MAXPLEN) {
-=09=09*prob_offset =3D (u8 *)&fhdr->frag_off - skb_network_header(skb);
-=09=09/* note that if prob_offset is set, the skb is freed elsewhere,
-=09=09 * we do not free it here.
-=09=09 */
-=09=09return -1;
+=09=09prob_offset =3D (u8 *)&fhdr->frag_off - skb_network_header(skb);
+=09=09net_dbg_ratelimited("ip6_frag_queue: Oversized IPv6 packet from %pI6=
c, end =3D %d\n",
+=09=09=09=09    &fq->q.key.v6.saddr, end);
+=09=09goto send_param_prob;
 =09}

As long as the IP fragment length exceeds 65535, I will discard the entire =
fragment queue.
