Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4817F169AFF
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgBWXwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:52:14 -0500
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:46160 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726534AbgBWXwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:52:13 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id D417018011E65;
        Sun, 23 Feb 2020 23:52:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2692:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3873:3874:4321:4605:5007:7875:7903:9040:10004:10400:10848:11026:11232:11473:11658:11914:12043:12048:12295:12296:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21433:21451:21611:21627:21740:21939:30012:30034:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: look71_876f7d9380335
X-Filterd-Recvd-Size: 2193
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sun, 23 Feb 2020 23:52:10 +0000 (UTC)
Message-ID: <cba75ee4d88afdf118631510ad0f971e42c1a31c.camel@perches.com>
Subject: Re: [PATCH v3] staging: qlge: emit debug and dump at same level
From:   Joe Perches <joe@perches.com>
To:     Kaaira Gupta <kgupta@es.iitr.ac.in>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 23 Feb 2020 15:50:43 -0800
In-Reply-To: <20200223173132.GA13649@kaaira-HP-Pavilion-Notebook>
References: <20200223173132.GA13649@kaaira-HP-Pavilion-Notebook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-02-23 at 23:01 +0530, Kaaira Gupta wrote:
> Simplify code in ql_mpi_core_to_log() by calling print_hex_dump()
> instead of existing functions so that the debug and dump are
> emitted at the same KERN_<LEVEL>
[]
> Also, can you please help me understand how are are numbers 32 and 4
> chosen for the function print_hex_dump()?

Emit 32 bytes per line in 4 byte chunks as u32

And below:

> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
[]
> @@ -1324,27 +1324,10 @@ void ql_mpi_core_to_log(struct work_struct *work)
>  {
>  	struct ql_adapter *qdev =
>  		container_of(work, struct ql_adapter, mpi_core_to_log.work);
[]
> +	print_hex_dump(KERN_DEBUG, "Core is dumping to log file!\n",
> +		       DUMP_PREFIX_OFFSET, 32, 4, qdev->mpi_coredump,
> +		       sizeof(*qdev->mpi_coredump), false);

This use of a prefix string is not acceptable.

From the kernel-doc:

/**
 * print_hex_dump - print a text hex dump to syslog for a binary blob of data
 * @level: kernel log level (e.g. KERN_DEBUG)
 * @prefix_str: string to prefix each line with;
 *  caller supplies trailing spaces for alignment if desired

So this would emit "Core is dumping..." line for for
every line of hex output.


