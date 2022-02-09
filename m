Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1424AEB01
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237521AbiBIH1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237504AbiBIH1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:27:45 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B8DC0613CB;
        Tue,  8 Feb 2022 23:27:48 -0800 (PST)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644391664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BNdeWlWyJwoe/Qown8c9HOfU3XoCi4raioSLrTWzgSM=;
        b=Wnd4EZdeuWWYLHzuzCdr851hSbcsCfGjQttMK68AorQxXwqfe1jgF7pzrn7tX7iKpiPM3C
        LlbDTd4ILn5cA8cRMv3uKb6rBWHdLnErfAn8uHy9CFW3pRMGeIzF9QQrWvaJbXyWto1mG9
        phSNVfbeeiltzcI/sgpgr4TttTkeHdA=
Date:   Wed, 09 Feb 2022 07:27:44 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <e95e51e3cdf771650ae64d5295e1178a@linux.dev>
Subject: Re: [PATCH net-next] net: dev: introduce netdev_drop_inc()
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220208195306.05a1760f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220208195306.05a1760f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220208162729.41b62ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220208064318.1075849-1-yajun.deng@linux.dev>
 <753bb02bfa8c2cf5c08c63c31f193f90@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

February 9, 2022 11:53 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:=0A=
=0A> On Wed, 09 Feb 2022 02:20:07 +0000 yajun.deng@linux.dev wrote:=0A> =
=0A>> February 9, 2022 8:27 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:=
=0A>> =0A>> On Tue, 8 Feb 2022 14:43:18 +0800 Yajun Deng wrote:=0A>> =0A>=
> We will use 'sudo perf record -g -a -e skb:kfree_skb' command to trace=
=0A>> the dropped packets when dropped increase in the output of ifconfig=
.=0A>> But there are two cases, one is only called kfree_skb(), another i=
s=0A>> increasing the dropped and called kfree_skb(). The latter is what=
=0A>> we need. So we need to separate these two cases.=0A>> =0A>> From th=
e other side, the dropped packet came from the core network and=0A>> the =
driver, we also need to separate these two cases.=0A>> =0A>> Add netdev_d=
rop_inc() and add a tracepoint for the core network dropped=0A>> packets.=
 use 'sudo perf record -g -a -e net:netdev_drop' and 'sudo perf=0A>> scri=
pt' will recored the dropped packets by the core network.=0A>> =0A>> Sign=
ed-off-by: Yajun Deng <yajun.deng@linux.dev>=0A>> =0A>> Have you seen the=
 work that's being done around kfree_skb_reason()?=0A>> =0A>> Yes, I saw =
it. The focus of kfree_skb_reason() is trace kfree_skb() and the reason,=
=0A>> but the focus of this patch only traces this case of the dropped pa=
cket.=0A>> =0A>> I don't want to trace all kfree_skb(), but I just want t=
o trace the dropped packet.=0A>> =0A>> This command 'sudo perf record -g =
-a -e skb:kfree_skb' would trace all kfree_skb(),=0A>> kfree_skb() would =
drowned out the case of dropped packets when the samples were too large.=
=0A> =0A> IIRC perf support filters, I think with -f? We can't add a trac=
epoint=0A> for every combination of attributes.=0A=0AYes, we can use a co=
mmand like this: " sudo perf record -g -a -e skb:kfree_skb --filter 'prot=
ocol =3D=3D 0x0800' ",=0AHowever, only the filter is defined in kfree_skb=
 tracepoint are available.=0A=0AThe purpose of this patch is record {rx_d=
ropped, tx_dropped, rx_nohandler} in struct net_device, to distinguish =
=0Awith struct net_device_stats. =0A=0AWe don't have any tracepoint recor=
ds {rx_dropped, tx_dropped, rx_nohandler} in struct net_device now. =0ACa=
n we add {rx_dropped, tx_dropped, rx_nohandler} in kfree_skb tracepoint? =
 like this:=0A=0A        TP_STRUCT__entry(=0A                __field(void=
 *,         skbaddr)=0A                __field(void *,         location)=
=0A                __field(unsigned short, protocol)=0A                __=
field(enum skb_drop_reason,   reason)=0A                __field(unsigned =
long,  rx_dropped)=0A                __field(unsigned long,  tx_dropped)=
=0A                __field(unsigned long,  rx_nohandler)=0A=0A        ),=
=0A=0A        TP_fast_assign(=0A                __entry->skbaddr =3D skb;=
=0A                __entry->location =3D location;=0A                __en=
try->protocol =3D ntohs(skb->protocol);=0A                __entry->reason=
 =3D reason;=0A                __entry->rx_dropped   =3D (unsigned long)a=
tomic_long_read(&skb->dev->rx_dropped);=0A                __entry->tx_dro=
pped   =3D (unsigned long)atomic_long_read(&skb->dev->tx_dropped);=0A    =
            __entry->rx_nohandler =3D (unsigned long)atomic_long_read(&sk=
b->dev->rx_nohandler);=0A        ),=0A=0AIf so, we can record this but no=
t add a tracepoint.
