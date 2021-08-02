Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C017E3DD49D
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 13:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhHBL0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 07:26:11 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:9568
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232553AbhHBL0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 07:26:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irFoAl0c+o8dNCNie6nXfn5yIR0XPi5pTjKYxyYgBTXXm+IfutZ/QwfwLqrz8z8LLZA5iM+YBTTbT+JHFUTTw/C8OP8sctvSTtFbPOI8959QLFthRp11t5fFQxU69b0W4BXV+QzwE/cwPFc5MFeLG9GgZN70x2MYd/uJ0SqXNV0wfcoyl3Vs1NTszwRgka02mKwcD4soRSzV45v/ThKeosF3qPRQ/Xdve0xQf8wVAXqMyyA0nkX1QHpKLclG4D2qyiGDmhQZjxOxjtpeTl8FY8ds12qr7LyqeCtQ5Hbfyy+zxFVRha2LrJ0J58H4LJXQyaXkNQgGXZEsdiHLB0wDyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Tchkr5EshUZ+VhYo8sfhY+0gq5sEusPRP1T43T7yqA=;
 b=oOnWw+5CDzLycyS0hbNxAa0ltcepiEnRsTGZjZU/IIxUCgyQeTzErYQnrZ+NtpkiLhuZGqJVMaUPXsWSNF7gEwDtAbuCd1lMBlb80/b3AkgZQ6yUmjUJV5PIB5BihelUbBdClSb4HP8PSAnQmUq0347WXWNqcKanEkct8CBGVKuIBNeN4oWplwo3B+1DwUKcxjgi1pTswSCVVUI/bYiYBpOgK8JMm1g57ephCR+DA5im1TVDC9+T5kfEsn8Xa1u5xm80BKs/EFyEMvY+QG89tx20nXZSU/8UNIwoiiPb1A4WA72nSxAntW6jXmxqz05vd0SBc+22RjMx37xY8pnXmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Tchkr5EshUZ+VhYo8sfhY+0gq5sEusPRP1T43T7yqA=;
 b=hd1PLwgPFI95jTEBIIkghx1jjxzyFU3w6nhiI99Q6q3vmdU8GlZHEHyp7r2DxvHMLiruabO2vQEWEf9VF8eMZI7PCuD6XlZ2uYtB+7IDdXEW4q2qN4WcXpwq+rl2IFLFvG/k1NokvfUyTO0nPmEWrB63HvSWT6LzUZ0xj6UDdrObEOgNzfRVJpYCIuK3GX+z/tUqN8E9xwzmMb8MPp2eTmHjTJqOpswIC0aPhDTeE7L3Pq/xvERk7kNp3D1+pONj4OukeSW2ASrRPuwZFU6bvWbK4ptjocyS8ds4CTqlqj4p/2eaj1f97Ql6gRCgpd8g2YzdCqimmwXPIwQquwV6Xw==
Authentication-Results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5071.namprd12.prod.outlook.com (2603:10b6:5:38a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 11:26:00 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 11:26:00 +0000
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4fb26839-5ce5-99eb-e992-e1380cd36c2e@nvidia.com>
Date:   Mon, 2 Aug 2021 14:25:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210801231730.7493-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0003.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.206] (213.179.129.39) by ZR0P278CA0003.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 11:25:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34a2db65-b4ec-4b73-39c6-08d955a84e24
X-MS-TrafficTypeDiagnostic: DM4PR12MB5071:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB507185A30B15AC5952C1B303DFEF9@DM4PR12MB5071.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6FrBAjkdpl6CvEny5F/06tBcr3J2L7xEfBU5oGtmfURqSbtUPaVk2y48yEGaWdk6qSrW4pZNf4SXA3u0z3tilXyf+EIhs3zpWdterrF0Fk+oi4qt61uM9dqxtWd81jNY65parNniQ8pwCgfV+ytLnx6dmaTLJvl1IGiI19Y6KzJ1k6q/SduX2/QjC/5rAOIJRnd02eqakjsPk0dt2SnxA5iyW02iEwKxnsEnK23b42yhCIvsm4UA1/Up2XZtu5Px4eKzBRwnkFc5J9NYrZoOolI4ZTmtDVo1CfR+EUc2qdj7lyyLmFRXw2XjiUzhSAzrBsAy09JkOpgvS/rEQUUFOa/KlQjGhQe2sb0GkcwpeQZdfa5yfWn1JlT4HLb1x5tUutPaTzW2UT938XdnvBKvSNet8y3EuXIdLY4miU8YjHwDXMpovtJSM5+pZmQ9m48p5uU9anmwaLPokC3Nt6tkKU2y3Zb1kwKQmbxTAsFy/2Mcia+YlzLsxCcc+PMeT4aeF1fTEW4HZYpAeB/mT7aPQHgxfPdTcy0+zpqDUq+2eSqdeMFRFeVwqvK45lOfA1p8a0voCPzmc1xAMq9Jdn60f9+HMyOGPFV4SR91Cz4HDuhFz1aGqSKx4v0A4ISOxLqj+Pb+yTLjfS+bKuxCSgnsTKKMjZFcarIgNvMwb5iONdx3Akuzvr2hH26PL+meynEkqMAD/11WAvNhNMEuPTPWiewfWVFWImI9LxeTSQTK0wFGoaoqjM7JkiASCw/kdwuP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(8676002)(8936002)(26005)(38100700002)(186003)(53546011)(6486002)(86362001)(54906003)(2906002)(83380400001)(31686004)(2616005)(956004)(110136005)(16576012)(66946007)(6666004)(36756003)(66476007)(4326008)(66556008)(316002)(478600001)(31696002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ui9nSDNFTVU4NXhmVjhCUzkzaUdOQ3IvWloyVVBNVmlIME94dGExMmNuZDZO?=
 =?utf-8?B?SFk3TmdRK01MUm9PY3FmMGRoaTN4dVVWa2cxcy95cWFhUk91c3ZKZFMrS3pI?=
 =?utf-8?B?SjJrL2MvaDc2UWtpRGRESUYzVmZGWTRxNzZFMFZzd3NmUkNwZ0x2WmpCa3F5?=
 =?utf-8?B?ckdWMkZ4Z3dvSys1K013TVQybllFSWx3eW5BUmNMaTk5emVzRm1WNUhEeUpU?=
 =?utf-8?B?NVdPMnBXcWFVMWFUQmMrdTZRSFZiTjMyTGs4S2tyekgwNk1JU2diSXhmOEV4?=
 =?utf-8?B?dzB5YnpSalR5QTRUM2xHSFp4VTZkdWlXNG54b3daRFpPcHkrRndKWGZWYVQ3?=
 =?utf-8?B?R25ZTmRnY3M4VlJlMUxzWUN2Z29jNHVONytsL0VQTDJsZmd3d0tFYXlUanZV?=
 =?utf-8?B?ZDBHUjZpbUFHQU9laXVQU0RPbUx2UTZvNEx6b3pzWTZmVC9VRDFjV1RQczRj?=
 =?utf-8?B?TmRwOXA2Znd6bkFNNktreDhKZ1RMK0c1VjZrWkNzMmZEOGhMd2h3MTN3L2JC?=
 =?utf-8?B?bFBTbFRYSlVOMFlialVYeW0wbzBlMm04Nm5QcmlYYzg0L0oyN0NackJjWHBQ?=
 =?utf-8?B?eGtPUzZXUlAyRHpRaGEwN0V3ekN3YUFWMUEwVGkrdUx4QWJVSFpqWjdVWmQ1?=
 =?utf-8?B?b1Z0U2hISkppd1l3Q0ljT2dWc3FPbmFLbmtWNE1tbUk0YmJJb2VpcUU4TkZI?=
 =?utf-8?B?KzFPcWRXUTAyVy9MT2oweEFUQll0dThrcHlNejNjUkdjbmJ0UEF0Q2k3VlA5?=
 =?utf-8?B?azE4Zi83Y0w0RTF2czZkTmhsbWQ3aVJiTW1SMG0xVWZqc0loSHI3VHBnUy9v?=
 =?utf-8?B?NGh6WWJxUW5QbmkvWGVnc2dNZFI0amJ5dkV3YXFmY2MyeFhYWWZyZ05wZkFE?=
 =?utf-8?B?UEZyUk9Gc05NVmMzY3hYRUVwYnR5dkpvK21TTU9tdkUwSTBVVGgrWHI4OWpw?=
 =?utf-8?B?WEJYWFY1OE9NQ3I4NHVOc3ZUOWw4RmR6anN3Zmx5blo0TmZ4MXRjclZ6VVJN?=
 =?utf-8?B?Nk91YnhqakR1MHNEbERIeHdIcU9kd0N4WWZhNmRTSjZLQUhEb2FzQ2xvZTRG?=
 =?utf-8?B?UzhiTDFpUENsbUI3ZVRhWS8wN0w4WVUyeS9yM3ZFWVdDSmtMaW45S1BhVnU4?=
 =?utf-8?B?OVREcE5uWnlZVW42S2V5a01YY2FZRGlnWFRqSFVRQ2l6aGhEL3BlVXBMUFRw?=
 =?utf-8?B?WVVUbHZwVlIyU0hiejgxM1c0LzRMRDNwc0J2bXkyb0pZQmJmaXJjS0dIT3Jx?=
 =?utf-8?B?NWdRejRYYWc1clZqUGNEZTM4QWIvU01rbitMdnY3LzNPdEZ0blFLNGIrdDZU?=
 =?utf-8?B?SGpjYU9lTHRWZUIzdFVnWmpXbFNJYlNNODBEM1VRWWJ0RG9GdWZuMCtGaTRH?=
 =?utf-8?B?SFRNck1KY3pkaEcxd2RYMUJ6aHluVjY5TWc0cVprTkl2dVE1MEF0UnNEcWNJ?=
 =?utf-8?B?TGtnNE1RVzVhV2d3S3VMeUhPazhqeVUwNUphTTVSMWxrUVZqeURyRTFOL0U4?=
 =?utf-8?B?NENMb2x2K3FvYzBYSWVyQyswWjFma3pVcjlLRTZlVGFpaVk4Uk1FY25TR2tD?=
 =?utf-8?B?dTZOQ3hYb1lYSHdiSGdObnZINUt3MCtXV0tJcFBHb3BESm9BNnZiVEFyQnZW?=
 =?utf-8?B?aFUxYndRbmpqdHppa0NUY2F0MWVwS1ZMUTVCQXM2RFVoVGFlVG5DcjlScUt2?=
 =?utf-8?B?akZ0UHlxZ0ZaM3FKNS9QWm8wNk11RmlTN1ErVDlialhpdXo3RnhlSkdZTkhF?=
 =?utf-8?Q?qZXBv48LzCpBSoSEMwSUHeJCbC/G5hJA2ZAM8t4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a2db65-b4ec-4b73-39c6-08d955a84e24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 11:26:00.4325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCmsQFyWQszLEr2tDJ1ERpXIQVVpbFGk/xl0ppCzmjzwBrCMTmdHS8kk1CgbHXt4wbNuTfUPS6RIliIEJQJyjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/08/2021 02:17, Vladimir Oltean wrote:
> Currently it is possible to add broken extern_learn FDB entries to the
> bridge in two ways:
> 
> 1. Entries pointing towards the bridge device that are not local/permanent:
> 
> ip link add br0 type bridge
> bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static
> 
> 2. Entries pointing towards the bridge device or towards a port that
> are marked as local/permanent, however the bridge does not process the
> 'permanent' bit in any way, therefore they are recorded as though they
> aren't permanent:
> 
> ip link add br0 type bridge
> bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn permanent
> 
> Since commit 52e4bec15546 ("net: bridge: switchdev: treat local FDBs the
> same as entries towards the bridge"), these incorrect FDB entries can
> even trigger NULL pointer dereferences inside the kernel.
> 
> This is because that commit made the assumption that all FDB entries
> that are not local/permanent have a valid destination port. For context,
> local / permanent FDB entries either have fdb->dst == NULL, and these
> point towards the bridge device and are therefore local and not to be
> used for forwarding, or have fdb->dst == a net_bridge_port structure
> (but are to be treated in the same way, i.e. not for forwarding).
> 
> That assumption _is_ correct as long as things are working correctly in
> the bridge driver, i.e. we cannot logically have fdb->dst == NULL under
> any circumstance for FDB entries that are not local. However, the
> extern_learn code path where FDB entries are managed by a user space
> controller show that it is possible for the bridge kernel driver to
> misinterpret the NUD flags of an entry transmitted by user space, and
> end up having fdb->dst == NULL while not being a local entry. This is
> invalid and should be rejected.
> 
> Before, the two commands listed above both crashed the kernel in this
> check from br_switchdev_fdb_notify:
> 
> 	struct net_device *dev = info.is_local ? br->dev : dst->dev;
> 
> info.is_local == false, dst == NULL.
> 
> After this patch, the invalid entry added by the first command is
> rejected:
> 
> ip link add br0 type bridge && bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static; ip link del br0
> Error: bridge: FDB entry towards bridge must be permanent.
> 
> and the valid entry added by the second command is properly treated as a
> local address and does not crash br_switchdev_fdb_notify anymore:
> 
> ip link add br0 type bridge && bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn permanent; ip link del br0
> 
> Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
> Reported-by: syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


