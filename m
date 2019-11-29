Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598AD10D18C
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 07:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfK2GoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 01:44:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfK2GoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 01:44:14 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8869145F611E;
        Thu, 28 Nov 2019 22:44:13 -0800 (PST)
Date:   Thu, 28 Nov 2019 22:44:13 -0800 (PST)
Message-Id: <20191128.224413.2026858682315234984.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, borisp@mellanox.com,
        aviadye@mellanox.com, daniel@iogearbox.net
Subject: Re: [PATCH net 0/8] net: tls: fix scatter-gather list issues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 Nov 2019 22:44:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 27 Nov 2019 12:16:38 -0800

> This series kicked of by a syzbot report fixes three issues around
> scatter gather handling in the TLS code. First patch fixes a use-
> -after-free situation which may occur if record was freed on error.
> This could have already happened in BPF paths, and patch 2 now makes
> the same condition occur in non-BPF code.
> 
> Patch 2 fixes the problem spotted by syzbot. If encryption failed
> we have to clean the end markings from scatter gather list. As
> suggested by John the patch frees the record entirely and caller
> may retry copying data from user space buffer again.
> 
> Third patch fixes a bug in the TLS 1.3 code spotted while working
> on patch 2. TLS 1.3 may effectively overflow the SG list which
> leads to the BUG() in sg_page() being triggered.
> 
> Patch 4 adds a test case which triggers this bug reliably.
> 
> Next two patches are small cleanups of dead code and code which
> makes dangerous assumptions.
> 
> Last but not least two minor improvements to the sockmap tests.
 ...

Series applied and queued up for -stable, thanks Jakub.
