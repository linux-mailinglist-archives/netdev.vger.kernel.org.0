Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647DF1E9755
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 13:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgEaLj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 07:39:26 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:7617
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725898AbgEaLjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 07:39:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eh/c956dm9CYKYdhmx5oIHZN7o9Tfo/ZUysYNDNxJdNK2VfrU0Jgxt+YkN0+hditYFKqPeA0IFhLhVIRnlx0ypVe6PlpeOmsickqv3TFNLYoOlJBcaZTvjmIzSANwkpNbfFLnqkC/ewQbDTElpedC1n8UXeEk528Hz4zMlPdxG/tQ/U7LTt73EIX3U07cbU4xh28tv0PGfPU2Hxr83EnwJ28ye2q+nVZb+KxPRSzl7ELAhQakUnB0PDZoxBlibNAhcz81A9TLAecWcK9SOFUbWU7EVBDNJXXZPs/JYGYUwg70IF8XlrU//NmWBhLwQqhc//wB4Ypz5iGaYhKSmxv2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j0nMBXeTi2HHspFQAuYpVITkLg038Fd7TCk6msXpX8=;
 b=ZeV94koO191u1KE0GO3Duih3WN/HvO0rfRocuzz9bzqDRfe75j6Ugar11PeMW4IYulXj8V5nu2eBial5MeWbq5ylZF17p94YpWce3bRhKKzo6RXE7LY74shiLeak+F8iRclHha7WGOJaB4ZMM/4TVFTUyA7JmfjE4BKu4+wQjWakCUdWLOHGYKaClNF/zf8MYmSw9Ge2UH1nJv+0IR/e0LKvA2YmjNmWJ08y5mxr5led2Lsb9HFvgOUCn3YM0k01al5BUZiTjEW8adXF3bTT7WqW3TppQpMcWIR7YvDSSwrKOGH2FjenqORQR9ZoYqZnNaWwwj9mrDHth4UBRQbwfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j0nMBXeTi2HHspFQAuYpVITkLg038Fd7TCk6msXpX8=;
 b=FhTjpqdgzJmLfK8LHUOIoh3RO2J5SoO8iWThQ3lL5kkGZvjSMvIAmhM/YrC6If9tksooSUQMw4NyFsGYL51qtcIokoXbgtD2D0ILKzmmh75mH/i1P5+rx2NzJiruylQpvpvQbBvIfLNfqo3ScUx+9gj7Xx0NFx/i5VA7V/gdHv0=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM7PR05MB6695.eurprd05.prod.outlook.com (2603:10a6:20b:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Sun, 31 May
 2020 11:39:19 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f%8]) with mapi id 15.20.3045.022; Sun, 31 May 2020
 11:39:19 +0000
Subject: Re: [PATCH net] net/tls: Fix driver request resync
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
References: <20200520151408.8080-1-tariqt@mellanox.com>
 <20200520133428.786bd4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6d488bcb-48ac-f084-069e-1b29d0088c07@mellanox.com>
 <20200528102953.4bfc424f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <3525a763-17dd-e126-8684-3bfcd7c26818@mellanox.com>
Date:   Sun, 31 May 2020 14:38:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200528102953.4bfc424f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:207:3::32) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM3PR05CA0154.eurprd05.prod.outlook.com (2603:10a6:207:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Sun, 31 May 2020 11:39:18 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ac411e4-181e-4a02-1484-08d8055741c3
X-MS-TrafficTypeDiagnostic: AM7PR05MB6695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB66952D67A41C6FDFB5FE0A6CB08D0@AM7PR05MB6695.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0420213CCD
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r++67uuP2wA4ypAOIH9SfOLfPLvz+SeD2Qd/PE+q5OgkgX0X2gOy22AC0GoDtDGI2/eqzE+BDms18UBQYuREW7+wM4RoYaUYEqnHPeFEQGGI3RAANUrxD+doCyqnMtAfmyssWZ915DJPGzbEWd5bIgynHOi8Pobj9G8LIwPm0xCOI5mmeBDkhtdimKbtJlr2V+kSIndHGZL7D7MeZCrb52Waish5Wd7CQ5u/tyfFiyAW4jBS+nlbeb259OpTdiEZ6B0qYo3tpVd5adJZn8FuyS9Kp+O8zqMlnIN6iKnq07uI7+cXmtWibvb6Zi3Z3tbPb5hzLsevusCH6k8BA9zqtYSfaaKANqMS9d5TZhEhIEhaGIZU8bnvR7S5BYzQ9bgX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(107886003)(4326008)(6666004)(478600001)(66946007)(66556008)(66476007)(31696002)(186003)(16526019)(86362001)(6486002)(16576012)(316002)(36756003)(2906002)(26005)(6916009)(83380400001)(2616005)(52116002)(54906003)(8936002)(31686004)(8676002)(5660300002)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0c3JTMZpcC40YXLOydtCh+flocX+OmJVJ2UqPx1wpbKUUDhsHJfBnbJgRiQ5lqzef/AAweQYSCe32AzmBiMH9M4IFFD4q62tXHN+vXOUNW5ZWJY4dZTQgjzSi7bMYFm5iCoPgq6kb/lk45hsNHi+mjBTFoyUP1hUMfMPfIl70QbtofnUy5E9WYAMasarXsUDMMACcdlg1zM1fTpVYyCFSDWX2pQbUM/8sb+kfDH1V3h0b+0xbqWEDL5iVl7jer3NTpX9pDH6LXOKXeF97dy5gt8TE35Zcjp+oCMCkonOb2Z14vRsBewn+JB/Qj6v+krOaeLoSAFdJgQ7LL/vD4QyrKi2+9PwEvG3UGeKJpnU7HTd1NR/jXz4+QBq6leqxdpO0h5SjMwIi3aSjrdZO8PXhxSDHXqPhry+upJcQ2wbbFOV7J61ycUnEhYPXXYhGUtlFbQLgl1HZRWs/I83KnEKPsvHTYXNtgD+197iUiljmnxzIbqCkx7h5MeArOisyzdS
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac411e4-181e-4a02-1484-08d8055741c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2020 11:39:19.8045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nAgJHZOUnMS/NwQAltT15qsJY41qTge2nb763JbBM5b1e+Uf2Iny8CKVo3JMq+zmuzdvpo9QU7OLrQKXC+5qAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6695
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>
>> Yes, although I would phrase it differently: the kernel would indicate to the driver,
>> that the resync request is wrong, and that it can go back to searching for a header.
>> If there are any drivers that need an extra check, then we can add it in the driver itself.
> 
> I'd rather make the API clear and use a different op to indicate this is
> a reset rather than a valid sync response. sync callback already has
> the enum for sync type.
> 

Sure, so we will add another flag to `tls_offload_rx_resync_request` and respin this patch with driver changes which use it.

>>> Kernel usually can't guarantee that the notification will happen,
>>> (memory allocation errors, etc.) so the device needs to do the
>>> restarting itself. The notification should not be necessary.
>>>  
>>
>> Usually, all is best effort, but in principle, reliability should be guaranteed by higher layers to simplify the design.
> 
> Since we're talking high level design perspectives here - IMO when you
> talk to FW on a device - it's a distributed system. The days when you
> could say driver on the host is higher layer ended when people started
> putting fat firmwares on the NICs. So no, restart has to be handled by
> the system making the request. In this case the NIC.
> 

When the driver talks to the device, then the driver is responsible to ensure messages are received reliably - no doubt about that.

>> On the one hand, resync depends on packet arrival, which may take a while, and implementing different heuristics in each driver to timeout is complex.
>> On the other hand, assuming the user reads the record data eventually, ktls will be able to deliver the resync request, so implementing this in the tls layer is simple.
> 
> We definitely not want any driver logic here - the resync restart logic
> has to be implemented on the device.
> 

Restart can be triggered by the device if there is traffic, as it would identify bad record headers. But, otherwise, software should help restart the device.
From an API perspective, I think it makes little sense for the device to send a request without any response from the TLS layer, as it is now; this patches fixes this.

>> In this case, I see no reason for the tls layer to fail --- did you have a specific flow in mind?
>> AFAICT, there are no memory allocation/error flows that will prevent the driver to receive a resync without an error on the socket (bad tls header).
>> If tls received the header, then the driver will receive the resync call, and it will take responsibility for reliably delivering it to HW.
> 
> So you're saying the request path and the response path for resync are
> both 100% lossless both on the NIC and the host? There is no scenario
> in which queue overflows, PCIe gets congested, etc.?
> 

Not at all.
As I've mentioned above "all is best effort", but we try our best to make things work when all is in proper order. In our case, resync is fully implemented in ASIC, so no FW failures. This leaves only hardware and host software failures. Hardware failures will likely cause the entire NIC to restart, closing all queues in the process. Software failures should be handled by each layer respectively. In the TLS layer, all is very simple and I see no reason for failure. Each driver should handle its own reliability trade-offs according to its own goals, which might vary from vendor to vendor and device to device.
