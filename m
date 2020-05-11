Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1D41CE1AD
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 19:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgEKR2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 13:28:06 -0400
Received: from correo.us.es ([193.147.175.20]:37348 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730731AbgEKR2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 13:28:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0C341C41C1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 19:28:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F06A11541C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 19:28:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 84BD711540C; Mon, 11 May 2020 19:28:04 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9105A52CB1;
        Mon, 11 May 2020 19:28:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 May 2020 19:28:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 71BA942EF52A;
        Mon, 11 May 2020 19:28:02 +0200 (CEST)
Date:   Mon, 11 May 2020 19:28:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: Remove
 WQ_MEM_RECLAIM from workqueue
Message-ID: <20200511172802.GA2064@salvia>
References: <20200510105543.13546-1-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510105543.13546-1-roid@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 01:55:43PM +0300, Roi Dayan wrote:
> This workqueue is in charge of handling offloaded flow tasks like
> add/del/stats we should not use WQ_MEM_RECLAIM flag.
> The flag can result in the following warning.
> 
> [  485.557189] ------------[ cut here ]------------
> [  485.562976] workqueue: WQ_MEM_RECLAIM nf_flow_table_offload:flow_offload_worr
> [  485.562985] WARNING: CPU: 7 PID: 3731 at kernel/workqueue.c:2610 check_flush0
> [  485.590191] Kernel panic - not syncing: panic_on_warn set ...
> [  485.597100] CPU: 7 PID: 3731 Comm: kworker/u112:8 Not tainted 5.7.0-rc1.21802
> [  485.606629] Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.4.3 01/177
> [  485.615487] Workqueue: nf_flow_table_offload flow_offload_work_handler [nf_f]
> [  485.624834] Call Trace:
> [  485.628077]  dump_stack+0x50/0x70
> [  485.632280]  panic+0xfb/0x2d7
> [  485.636083]  ? check_flush_dependency+0x110/0x130
> [  485.641830]  __warn.cold.12+0x20/0x2a
> [  485.646405]  ? check_flush_dependency+0x110/0x130
> [  485.652154]  ? check_flush_dependency+0x110/0x130
> [  485.657900]  report_bug+0xb8/0x100
> [  485.662187]  ? sched_clock_cpu+0xc/0xb0
> [  485.666974]  do_error_trap+0x9f/0xc0
> [  485.671464]  do_invalid_op+0x36/0x40
> [  485.675950]  ? check_flush_dependency+0x110/0x130
> [  485.681699]  invalid_op+0x28/0x30

Applied, thanks.
