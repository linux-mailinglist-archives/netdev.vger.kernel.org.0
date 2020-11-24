Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0A42C29B6
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389153AbgKXObm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389145AbgKXObl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 09:31:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B682520674;
        Tue, 24 Nov 2020 14:31:39 +0000 (UTC)
Date:   Tue, 24 Nov 2020 09:31:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: netconsole deadlock with virtnet
Message-ID: <20201124093137.48d1e603@gandalf.local.home>
In-Reply-To: <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
References: <20201117102341.GR47002@unreal>
        <20201117093325.78f1486d@gandalf.local.home>
        <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
        <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
        <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
        <20201118091257.2ee6757a@gandalf.local.home>
        <20201123110855.GD3159@unreal>
        <20201123093128.701cf81b@gandalf.local.home>
        <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201123140934.38748be3@gandalf.local.home>
        <20201123112130.759b9487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 11:22:03 +0800
Jason Wang <jasowang@redhat.com> wrote:

> Btw, have a quick search, there are several other drivers that uses tx 
> lock in the tx NAPI.

tx NAPI is not the issue. The issue is that write_msg() (in netconsole.c)
calls this polling logic with the target_list_lock held.

Are those other drivers called by netconsole? If not, then this is unique
to virtio-net.

-- Steve
