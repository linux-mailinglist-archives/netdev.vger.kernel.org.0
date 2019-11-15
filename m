Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735E7FE739
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 22:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfKOVfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 16:35:01 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33469 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfKOVfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 16:35:01 -0500
Received: by mail-qt1-f194.google.com with SMTP id y39so12390289qty.0
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 13:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FJe4UaT3jq0Q9t7CJYZVW9r9K3xiYqwnQxTLD0py+eA=;
        b=TrEyQiyV6PFP5l+vJirjBjA6bfOO795hOcSSr/asdAp+RsNh4i3wsZdm8a5n5GNpw2
         ziseg4YBNRoHUY7dKn0nduonLBh7rz1baRU/fqhXGJ5BKT8SVxMsL9t8yzzOB2lNrRYK
         uHmss8lHB5M8FEw2z+ZQY8G8eOXEJSGQJGnlktXAKfCTouoyXVIrxIMeCZgLZFf8MAH3
         j91+tmrqkM5B4WORBrn7X3qHwl/4jXXsErPiFZg1+HyutyfBeyk5NMMDYLUBGbzjYaMG
         L8NzNK2j/lCsq5khvi0W0zKl1Dzba3ew1/n71wGHlFw64JPfwhUps9ci5CG9gCU/zdjW
         kIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FJe4UaT3jq0Q9t7CJYZVW9r9K3xiYqwnQxTLD0py+eA=;
        b=aPGu/vaHr1dHZalTrIu+RkxjDMgmj+RFbP0HJ/bABmpz3eI7TPzZrs7d3vWjzqyVQg
         756e9jZWSZMEgP9DY3jMuXege5RFEzrMdb4XWbSrWXzsbuLQz5eUUKwY/djLTrx+hViu
         o/IQop3ukfEfs2PBa08/5x7AtB6mQ+kDCsqALXsOd0HhQB1LhmBQmjAqFMJjFAcb8m2H
         Tr2flk5zGwI3hP/MFrzqfOvR9iSgM9xdobutF7exw/0CBusi2jBbS5Ar+npVGO4pB3m1
         nutzkpQfXRjUWrvJheUyMd+MwM9IdLxOOfgGp3rTgjJzD1GbPtcsK3JHN2thJlEPE4fB
         udnA==
X-Gm-Message-State: APjAAAW/hIxDwcxt6Bj6kfLY8OVOWLre2meN2YNdNP3Y7RjPTM72JbMy
        P8kKYA2evXNF51FhS2jg1hJwDVU/srlD4/xHGZM=
X-Google-Smtp-Source: APXvYqxptxRquTE6JU+9w/ao0HB80+Wx5QlPv/QRo1xgN00viDU2KreFyBzp1lC28WaFhAHYVxnpJHP5k1RWa6ShTkE=
X-Received: by 2002:ac8:2598:: with SMTP id e24mr16564569qte.189.1573853699889;
 Fri, 15 Nov 2019 13:34:59 -0800 (PST)
MIME-Version: 1.0
References: <20191109124205.11273-1-popadrian1996@gmail.com> <20191115201508.GF24205@lunn.ch>
In-Reply-To: <20191115201508.GF24205@lunn.ch>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Fri, 15 Nov 2019 21:34:21 +0000
Message-ID: <CAL_jBfTX7jnbQ7Ydxt=Q1avH+H8j+TD_gWY0ioJrexQ=_nZhgg@mail.gmail.com>
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew!

The QSFP-DD support I added doesn't replace and/or overrides the
current QSFP support and memory mapping. When I started developing
this, I tried to reuse as much as the old code as possible, but most
of the properties where placed at totally different offsets.

In qsfp.c, I added this:

void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
{
    if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD) {
        qsfp_dd_show_all(id, eeprom_len);
    return;
    }
    [...]

This was needed because although modinfo.type (see ethtool.c,
do_getmodule) is still ETH_MODULE_SFF_8636, the byte in the eeprom
containing the ID was different (0x18 for QSFP-DD). Since QSFP and
QSFP-DD were not fully backwards compatible, I decided to use the ID
to differentiate between them (this is done in the same way for QSFP+
for example).

If I run an older version of ethtool on an interface from a network
card having a QSFP-DD transceiver plugged in, the tool prints 0x18 and
exits. With my changes, if we have a QSFP-DD, the tool prints the
correct stats without altering the old flow for normal QSFPs.

Of course, as you stated in the previous messages, it still looks like
I'm trying to define an KAPI. If we still want to keep page 3 and just
append 0x10 and 0x11 after it, that can be easily done (although there
aren't any stats needed for QSFP-DD that are found in page 0x03).

Adrian

On Fri, 15 Nov 2019 at 20:15, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Nov 09, 2019 at 02:42:05PM +0200, Adrian Pop wrote:
> > The Common Management Interface Specification (CMIS) for QSFP-DD shares
> > some similarities with other form factors such as QSFP or SFP, but due to
> > the fact that the module memory map is different, the current ethtool
> > version is not able to provide relevant information about an interface.
> >
> > This patch adds QSFP-DD support to ethtool. The changes are similar to
> > the ones already existing in qsfp.c, but customized to use the memory
> > addresses and logic as defined in the specifications document.
> >
> > Page 0x00 (lower and higher memory) are always implemented, so the ethtool
> > expects at least 256 bytes if the identifier matches the one for QSFP-DD.
> > For optical connected cables, additional pages are usually available (the
> > contain module defined  thresholds or lane diagnostic information). In
> > this case, ethtool expects to receive 768 bytes in the following format:
> >
> >     +----------+----------+----------+----------+----------+----------+
> >     |   Page   |   Page   |   Page   |   Page   |   Page   |   Page   |
> >     |   0x00   |   0x00   |   0x01   |   0x02   |   0x10   |   0x11   |
> >     |  (lower) | (higher) | (higher) | (higher) | (higher) | (higher) |
> >     |   128B   |   128B   |   128B   |   128B   |   128B   |   128B   |
> >     +----------+----------+----------+----------+----------+----------
>
> Hi Adrian
>
> From ethtool/qsfp.c
>
>  *      b) SFF 8636 based 640 bytes memory layout is presented for parser
>  *
>  *           SFF 8636 based QSFP Memory Map
>  *
>  *           2-Wire Serial Address: 1010000x
>  *
>  *           Lower Page 00h (128 bytes)
>  *           ======================
>  *           |                     |
>  *           |Page Select Byte(127)|
>  *           ======================
>  *                    |
>  *                    V
>  *           ----------------------------------------
>  *          |             |            |             |
>  *          V             V            V             V
>  *       ----------   ----------   ---------    ------------
>  *      | Upper    | | Upper    | | Upper    | | Upper      |
>  *      | Page 00h | | Page 01h | | Page 02h | | Page 03h   |
>  *      |          | |(Optional)| |(Optional)| | (Optional) |
>  *      |          | |          | |          | |            |
>  *      |          | |          | |          | |            |
>  *      |    ID    | |   AST    | |  User    | |  For       |
>  *      |  Fields  | |  Table   | | EEPROM   | |  Cable     |
>  *      |          | |          | | Data     | | Assemblies |
>  *      |          | |          | |          | |            |
>  *      |          | |          | |          | |            |
>  *      -----------  -----------   ----------  --------------
>
> I don't think dropping page 3 is good for backwards/forwards
> compatibility. An old ethtool is going to decode what it thinks is
> page 3 when in fact it is page 0x10. For backwards compatibility, you
> should not dropping page 3, but append pages 0x10 and 0x11 after page
> 3.
>
> Then there is the question, what do we do when page 4 is needed by
> some other module? Maybe the better solution is to wait until netlink
> ethtool is available. We can then label each page with an attribute
> indicate what page it actually is, and so allow sparse pages.
>
>          Andrew
