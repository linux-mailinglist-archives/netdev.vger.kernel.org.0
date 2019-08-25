Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224139C294
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 10:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfHYIfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 04:35:15 -0400
Received: from mail.nic.cz ([217.31.204.67]:45492 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfHYIfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 04:35:15 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id A9CB6140B72;
        Sun, 25 Aug 2019 10:35:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566722110; bh=/9/Fc4UsO5iC2I6oxW3Ikq3q+IMbCntkp4WUuj09j+c=;
        h=Date:From:To;
        b=LU3x8bu0blC09LSI2OaGbhDMBwh2zJM9bObMVaesbGr8e40s7YTS63YAXAUG87HnK
         fB2HPGBsrgejanXBZgdCFa5PK2/sTm3UL9JSVNMMNxKSXrhInk4qt4YTjVhNvduKTU
         dlxpjhF4st1RO7NYVBgJKrzAKmURwWb4av4X4/Oc=
Date:   Sun, 25 Aug 2019 10:35:10 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Subject: Re: Regresion with dsa_port_disable
Message-ID: <20190825103510.3811a264@nic.cz>
In-Reply-To: <20190824205349.GB27859@t480s.localdomain>
References: <20190824225306.GA15986@lunn.ch>
        <20190824191220.GB1808@t480s.localdomain>
        <20190824231653.GA17726@lunn.ch>
        <20190824205349.GB27859@t480s.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Aug 2019 20:53:49 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> OK I think you meant info->ops->serdes_irq_free and
> info->ops->serdes_irq_setup, otherwise it's confusing.
> 
> I think I know what's going on, I'll look into it soon.

Either dsa_port_setup is calling dsa_port_disable for
DSA_PORT_TYPE_UNUSED and this causes that, or, as line
  Workqueue: events deferred_probe_work_func
suggests, probe is deferred, dsa_tree_setup calls
dsa_tree_teardown_switches, and thus dsa_port_disable is called.
We should add a check into dsa_port_disable if that port was successfuly
enabled, or something like that.
