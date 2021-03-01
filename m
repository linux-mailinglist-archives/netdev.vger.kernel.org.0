Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE2D327E99
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 13:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhCAMts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 07:49:48 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14724 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbhCAMtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 07:49:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603ce2c10000>; Mon, 01 Mar 2021 04:49:05 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 12:49:04 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 12:48:39 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 1 Mar 2021 12:48:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLV+cKNIUt/6N9PjDxplSb9U1QJ95PelLnVHLaMTHN6k72Rfl8Oyb+ht1gZrKKsvBs/hXrQ+LUMn+Er6oD2IpYDdav5lpV1zPdW649NzNuU55YE325j2D/APhJQzaCtVb+FQqkfrw3mFCY3vm7AJ7AYUnhWw5SKhF4oDU7L5rYbj3Fs38LY62M3E1tBCkKi5UZX5ICR8tPM2VZkjR5yD5jiPIH9quL7lP+CVrh5z+N0jflnlA+KLCr3IPSad2GBjMFWA94KOwQtHGXpQrhF1v/vGX+3nfznvnt24u15GHcp2Mo0SWQ3t2AYJbGNc4ftCLMlzREZSAK2Pg62pJ0krMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ft86/QUvgjKD2y7oXbkkYXKLeR6WF+ZaO733OneUYpI=;
 b=n8MhrQ4Bu3wA/BK9GFs4BqyKYlzFNUISfKOAx8jwQ67bAckcbYyWA73CNPHkPLfQwDn37yIQrP8twwH0pfzmf5G9Gz2MxD2OW4j2XWBL9r/kSkpBSgz0ZxfRZP+vkE6deuY67T1W5hFogid0Cj64P5u8+ecG4+SGJVjZtPuIZzQzvSxtVOmIt2a0cT2X8DwdfSPakot0gr+9HqtinaBGpG02iQEEtLCz3Q/iZSzLvsoG6y0SfM6fG+9OfrvDufqVHTyDcWeER5PpRpVVAiZ4pDnBRAuPQ5i9vqctBdYjHANUhWRkK2O8Vwxyy1ClWcmsKOR64UlXyp1jb5ere5SIDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4778.namprd12.prod.outlook.com (2603:10b6:5:167::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Mon, 1 Mar
 2021 12:48:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3890.026; Mon, 1 Mar 2021
 12:48:36 +0000
Date:   Mon, 1 Mar 2021 08:48:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>, Mark Bloch <mbloch@nvidia.com>,
        "Adit Ranadive" <aditr@vmware.com>,
        Ariel Elior <aelior@marvell.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "Christian Benvenuti" <benve@cisco.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        "Gal Pressman" <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, <linux-rdma@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Nelson Escobar <neescoba@cisco.com>, <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        <target-devel@vger.kernel.org>,
        "VMware PV-Drivers" <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Zhu Yanjun" <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next] RDMA: Support more than 255 rdma ports
Message-ID: <20210301124834.GE4247@nvidia.com>
References: <20210301070420.439400-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210301070420.439400-1-leon@kernel.org>
X-ClientProxiedBy: BL0PR01CA0008.prod.exchangelabs.com (2603:10b6:208:71::21)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR01CA0008.prod.exchangelabs.com (2603:10b6:208:71::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Mon, 1 Mar 2021 12:48:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lGhyU-002UIW-MY; Mon, 01 Mar 2021 08:48:34 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614602945; bh=Ft86/QUvgjKD2y7oXbkkYXKLeR6WF+ZaO733OneUYpI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=OIpUzU4vBocfj+Fvi/btU4ITRvQF4Sjr7SzA+PAmmmvtIBz58JqbkaseUDWRScVk+
         7Uc7cpNwoYK2c7z2OUqTw8uHuTsGL00kxACPXpGL76nFwrrpKdCbWfyA7AcfVeVS8Y
         ESunQul2jgxzLqJA5kQaPciy1G1CBE/bXEkFqOVonUghq6ttuecSJoJcFQxFt29kXz
         ru7oyL8IxuLkPn9U7IvFdCYEuLHchkTD8wbNNIqgC9J/soaiYmNEGsUCK1iSTyLkLf
         udz+xFwZ61kEgRzQRbz5PPOuWDGGI9Hipz53vMtvTdSbt8sZrEpkD27EU5pJKPoyid
         Hbq1PVtcDlEsw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 09:04:20AM +0200, Leon Romanovsky wrote:
> @@ -884,7 +884,7 @@ static void gid_table_reserve_default(struct ib_device *ib_dev, u8 port,
> 
>  static void gid_table_release_one(struct ib_device *ib_dev)
>  {
> -	unsigned int p;
> +	u32 p;
> 
>  	rdma_for_each_port (ib_dev, p) {
>  		release_gid_table(ib_dev, ib_dev->port_data[p].cache.gid);
> @@ -895,7 +895,7 @@ static void gid_table_release_one(struct ib_device *ib_dev)
>  static int _gid_table_setup_one(struct ib_device *ib_dev)
>  {
>  	struct ib_gid_table *table;
> -	unsigned int rdma_port;
> +	u32 rdma_port;
> 
>  	rdma_for_each_port (ib_dev, rdma_port) {

Why are we changing this? 'unsigned int' is the right type for port
numbers

Jason
