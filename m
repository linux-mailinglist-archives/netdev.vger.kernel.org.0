Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FFC44E8F7
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 15:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbhKLOeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 09:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235238AbhKLOee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 09:34:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDCE60F45;
        Fri, 12 Nov 2021 14:31:42 +0000 (UTC)
Date:   Fri, 12 Nov 2021 09:31:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: snmp: tracepoint support for snmp
Message-ID: <20211112093140.373da4f7@gandalf.local.home>
In-Reply-To: <CADxym3YzMGG3gZ1X6gc=qF182Ow0iO+782Hjn3QvnFnRhfEbRA@mail.gmail.com>
References: <20211111133530.2156478-1-imagedong@tencent.com>
        <20211111060827.5906a2f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3bk5+3t9jFmEgCBBYHWvNJx6BJGdjk+-zqiQaJPtLM=Ug@mail.gmail.com>
        <20211111175032.14999302@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3YzMGG3gZ1X6gc=qF182Ow0iO+782Hjn3QvnFnRhfEbRA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 14:42:23 +0800
Menglong Dong <menglong8.dong@gmail.com> wrote:

> What's more, I have also realized another version: create tracepoint for every
> statistics type, such as snmp_udp_incsumerrors, snmp_udp_rcvbuferrors, etc.
> This can solve performance issue, as users can enable part of them, which
> may be triggered not frequently. However, too many tracepoint are created, and
> I think it may be not applicable.

If possible, it would be great to have a single tracepoint to handle all
statistics (not sure what data it will be having). Or at least break it
down to one tracepoint per group of statistics.

There's two approaches that can be taken.

1) Create a DECLARE_EVENT_CLASS() template that the group of tracepoints
use, and then create a DEFINE_EVENT() for each one. This will create a
separate trace event for each stat. Most the footprint of a trace event is
in the CLASS portion, so having a single class helps keep the size overhead
down.

2) Just use a single trace event for all stats in a group, but perhaps have
a type field for each to use. That way it can be easy to filter on a set of
stats to trace.

-- Steve
