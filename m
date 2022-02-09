Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F3B4AE6AE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 03:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbiBICkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 21:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244925AbiBICUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 21:20:11 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D97BC06157B;
        Tue,  8 Feb 2022 18:20:09 -0800 (PST)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644373207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=duEdvsmvfL1YUaUj/WhXeBPgED0TQAZfCHM+etVCeio=;
        b=gKRYgH1i4qRCdJmIiJSTJULASGNH0ILH45mJ3qZs5pLNrqBE6Jq8bEAF5yMT3z+ZsGPOW+
        j0BMVIeZCsfoZOerdHXrmWFsbem5kJ8W0DgmLIWE4zirnrYTXk+FarLHRWmRQW6EtLVGlU
        RBWNnyPtCnK7Sc51kRBBvARmysww1WA=
Date:   Wed, 09 Feb 2022 02:20:07 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <753bb02bfa8c2cf5c08c63c31f193f90@linux.dev>
Subject: Re: [PATCH net-next] net: dev: introduce netdev_drop_inc()
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220208162729.41b62ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220208162729.41b62ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220208064318.1075849-1-yajun.deng@linux.dev>
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

February 9, 2022 8:27 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:=0A=0A=
> On Tue, 8 Feb 2022 14:43:18 +0800 Yajun Deng wrote:=0A> =0A>> We will u=
se 'sudo perf record -g -a -e skb:kfree_skb' command to trace=0A>> the dr=
opped packets when dropped increase in the output of ifconfig.=0A>> But t=
here are two cases, one is only called kfree_skb(), another is=0A>> incre=
asing the dropped and called kfree_skb(). The latter is what=0A>> we need=
. So we need to separate these two cases.=0A>> =0A>> From the other side,=
 the dropped packet came from the core network and=0A>> the driver, we al=
so need to separate these two cases.=0A>> =0A>> Add netdev_drop_inc() and=
 add a tracepoint for the core network dropped=0A>> packets. use 'sudo pe=
rf record -g -a -e net:netdev_drop' and 'sudo perf=0A>> script' will reco=
red the dropped packets by the core network.=0A>> =0A>> Signed-off-by: Ya=
jun Deng <yajun.deng@linux.dev>=0A> =0A> Have you seen the work that's be=
ing done around kfree_skb_reason()?=0A=0AYes, I saw it. The focus of kfre=
e_skb_reason() is trace kfree_skb() and the reason, =0Abut the focus of t=
his patch only traces this case of the dropped packet.=0A=0AI don't want =
to trace all kfree_skb(), but I just want to trace the dropped packet.=0A=
=0AThis command 'sudo perf record -g -a -e skb:kfree_skb' would trace all=
 kfree_skb(),=0Akfree_skb() would drowned out the case of dropped packets=
 when the samples were too large.
