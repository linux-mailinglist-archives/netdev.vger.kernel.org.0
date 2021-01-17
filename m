Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD04B2F93FD
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 17:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbhAQQgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 11:36:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51376 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728368AbhAQQgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 11:36:17 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10HGRlXD009811;
        Sun, 17 Jan 2021 08:35:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=EmObHEiASYx2nBcvgux1ijz7tS4LTPzZRab4UsvMYnQ=;
 b=Xmdj2gvRlXrDq14JjCWmpDJ5um6WLgQ6vC4Mb5xynrP6ny/Gr6YAjngjrPBOExwROfJg
 dpnCotT0FUWcBNAJp/2ppB/y1Qy6JMM0cb8CHMnTFNuGYyHufaxn8CjP6FpX7VYrcrmf
 dHo5wYarTN+B9DYipZFrI4EzQbmjgaP1M2zMRpFh8L86a+Twz3lXoGvNUUUl/biQOgVb
 W1rohfm+WZ3UtYloiPb4O2V84Q2Mq+XgOtxPu5ZU7Gef4ahgYfVcpJNIoUpFEJIUOoGn
 rbb6QcLrn5dKx+PZ99ZRZ1C1N00qnYJlpBjyKCLB0AwwaiYdwYSmgdcwj8nFzmAnWYjy 8A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 363xcu9wmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 17 Jan 2021 08:35:35 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 17 Jan
 2021 08:35:34 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 17 Jan
 2021 08:35:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 17 Jan 2021 08:35:33 -0800
Received: from [10.193.38.82] (unknown [10.193.38.82])
        by maili.marvell.com (Postfix) with ESMTP id 032B53F7040;
        Sun, 17 Jan 2021 08:35:31 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH net-next 1/3] qede: add netpoll support for qede
 driver
To:     Jakub Kicinski <kuba@kernel.org>,
        Bhaskar Upadhaya <bupadhaya@marvell.com>
CC:     <netdev@vger.kernel.org>, Ariel Elior <aelior@marvell.com>
References: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
 <1610701570-29496-2-git-send-email-bupadhaya@marvell.com>
 <20210116182607.01f26f15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <5f6c49fc-8dfc-9d54-7d90-89a78cae9b2a@marvell.com>
Date:   Sun, 17 Jan 2021 17:35:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210116182607.01f26f15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-17_09:2021-01-15,2021-01-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Fri, 15 Jan 2021 01:06:08 -0800 Bhaskar Upadhaya wrote:
>> Add net poll controller support to transmit kernel printks
>> over UDP
> 
> Why do you need this patch? Couple years back netpoll was taught 
> how to pull NAPIs by itself, and all you do is schedule NAPIs.
> 
> All the driver should do is to make sure that when napi is called 
> with budget of 0 it only processes Tx completions, not Rx traffic.

Hi Jakub,

Thanks for the hint, we were not aware of that.

I see our driver may not handle zero budget accordingly. Will check.

But then, all this means .ndo_poll_controller is basically deprecated?

Regards,
   Igor
