Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA9A20A347
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390964AbgFYQqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:46:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48870 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390448AbgFYQqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:46:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PGexTv007953;
        Thu, 25 Jun 2020 09:46:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=PMskP27+of0ifwdKo+hHxFTCm0HJN0Am7pIewJiyYx8=;
 b=ZO2aUhxBDtLA4Z15aYe/UZJVtWr4ZFe8kF2J/QqbpPVxxpzg1k5oXPJQLdlDdSlCQFmS
 hr4s8lQW4BDLGUtf3MHix3ByqZfOvLIey/y76Z6tNuBI23L1HcbXmJEm+qsXvAV7nTO5
 ao01B4uxNE8fP5mqj8ASPY+ADgNdJiZ3AFAqWE/1V3t3RPNtm+g/EnxEzp0niY+kPKz+
 yts2fknu+0k4VG0T/K6IaTouyUnz9NbL2GzIL/u9UzxlRGZYQ5MZ9StmHxH829KKZxp6
 1V2ruqoDTqzw98NWSiIOLqD1690JjBz7kRthm34Cv5SKYAcu55uhonRj+187AJJLpGa0 TQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh0mqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 09:46:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Jun
 2020 09:46:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Jun 2020 09:46:27 -0700
Received: from [10.193.39.5] (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 969AB3F7040;
        Thu, 25 Jun 2020 09:46:22 -0700 (PDT)
Subject: Re: [EXT] [PATCH v1] bnx2x: use generic power management
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        <skhan@linuxfoundation.org>
References: <20200624175116.67911-1-vaibhavgupta40@gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <f685dfe2-9a50-15f5-f94f-c72433f84eb1@marvell.com>
Date:   Thu, 25 Jun 2020 19:46:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200624175116.67911-1-vaibhavgupta40@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_11:2020-06-25,2020-06-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/06/2020 8:51 pm, Vaibhav Gupta wrote:
> External Email
> 
> ----------------------------------------------------------------------
> With legacy PM, drivers themselves were responsible for managing the
> device's power states and takes care of register states.
> 
> After upgrading to the generic structure, PCI core will take care of
> required tasks and drivers should do only device-specific operations.
> 
> The driver was also calling bnx2x_set_power_state() to set the power state
> of the device by changing the device's registers' value. It is no more
> needed.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  | 15 ++++++---------
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h  |  4 +---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  3 +--
>  3 files changed, 8 insertions(+), 14 deletions(-)

Acked-by: Igor Russkikh <irusskikh@marvell.com>

Sudarsana, could you please give it a short sanity test and report back?

Thanks,
  Igor
