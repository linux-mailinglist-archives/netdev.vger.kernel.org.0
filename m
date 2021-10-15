Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891B142E6BB
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhJOCoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhJOCnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:43:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A150760E09;
        Fri, 15 Oct 2021 02:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634265709;
        bh=4POz6DgZAZA7Tn5eqUrqJ81ytlAarnS9BoLTIwuFTng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HZs85nOJOzJ0TGWdwuRzDlRiXZZy61C4AH6BS3P3bit7n93hAmV4GVdK9YbQTHG/S
         is6FH25jSK4jFeqhGdWJQ6uL1Uh3opaXk8BaDWK+q+E+A383JQNECNIfCyOZbfvYe8
         hrDVUhPJaSogySkAEroRmO1f3SW6QqPNdjvVzJpQrYgIPwMf5xGj2Tj6Svc9cGSKU6
         pquQJvXhhXo/aS9DIH1JkUW7lvNB3fMnu/SV2sfRqbpiq3wxxj5GKtgYf+EQVUw177
         BpgKPQfvo7qiko6p0rZlxpkq0lrzGX1AV2GsP0Mp40IVL3C6SWDkZ6GrudMfl0vyrA
         OB3TgkboZYO9g==
Date:   Thu, 14 Oct 2021 19:41:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        mkubecek@suse.cz, andrew@lunn.ch, amitc@mellanox.com,
        idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V4 net-next 0/6] ethtool: add support to set/get tx
 copybreak buf size and rx buf len
Message-ID: <20211014194146.168ca52b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211014131420.23598-1-alexandr.lobakin@intel.com>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
        <20211014131420.23598-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 15:14:20 +0200 Alexander Lobakin wrote:
> > Rx buf len is buffer length of each rx BD. Use ethtool -g command to get
> > it, and ethtool -G command to set it, examples are as follow:
> > 
> > 1. set rx buf len to 4096
> > $ ethtool -G eth1 rx-buf-len 4096
> > 
> > 2. get rx buf len
> > $ ethtool -g eth1
> > ...
> > RX Buf Len:     4096  
> 
> Isn't that supposed to be changed on changing MTU?
> And what if I set Rx buf len value lower than MTU? I see no checks
> as well.

Presumably the NIC does scatter.

> That means, do we _really_ need two new tunables?

nit let's not say tunable, "tunable" has an API meaning this one
is part of the ring param command.

The question of "why do we need this" seems fair tho - Guangbin,
can you share examples of workloads which benefit from 2k vs 4k?
