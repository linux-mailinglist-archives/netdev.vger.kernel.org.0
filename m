Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23573DD169
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 09:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhHBHnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 03:43:00 -0400
Received: from mail-dm6nam11on2040.outbound.protection.outlook.com ([40.107.223.40]:32225
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232249AbhHBHm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 03:42:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1HXspp33V1c+Ui0pTkWq04YxcJqPkcanWam+T4AvdjYaHGMurw2HPcgbVm0kngR1QGJZxOOZXjdKWvOooe5zHV32nmCFZhJDIW37vCWCv6mZtr4r8h6nFB2dmJ3KW8sULskSbG8qjsEKFTsqCbv4ooEUfN6qFSAyUysx3EV/ZJ8Vz6GVaHHgyDksezzU1I1NqZMLsR9s62CwjuQ6HaJaNhGJgNbNkKNq2GLZXx5cqhfEy9QvxVfWpd8kJUF81N7b92LdvfHgqzLr4OYMjawHvhx92ThIQG/qWdeM2vIPFe/TKJeLHlLN+MLTAw/UMWr+PEW7WeSlHk2WFrB1Mz+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvRo1UX7h+VvHifNiaqz/XjPnCfcGJA1fWCfAdRkgDs=;
 b=JKbvwQnOzEAztd9h1yfBbknff9y1LB8mtDkS1CQ7IGlyhM9WTpcvryJ19cehH1rXfZg7c+JN4+5Fr08gfIR6HEDbvlkJqvf23+osX+ZN1aOzVQWiHUnqbPVB1DdNIg6y4wSw6iUZB28ymZ5WcIUo24YE6J3zWnZfHfoTzXmV9SQOhrLeA8SQw2i3DZu4Mjlw7VZmmnvb3m+7OT9v3M5Jg868edtcETTUHwl/D9BbO71tqfzEheG1SZ+VEsYSvIHkQmwMdpxJ7mlqz4nV+7PdL1GRXCinQHc3eAHWwwRv/8U1bwDujwP+Itv6wjQ/c270uSqHXneAzr/wPlVqpkj0JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvRo1UX7h+VvHifNiaqz/XjPnCfcGJA1fWCfAdRkgDs=;
 b=oCep61/aYmSwaxoKXIR2eLqnjt7OVyVLLlf90WF7KYItVIazlNgUiF7ZMDTxrNIkgieDxDwtAsUeJZyGmfKRHIPJOwbqqA0q0Nh5IFyQ7ZPK0xErxfkYFDxq/F13b6cmFYN8DAg30wuzACCWVjzW/Wbjk3jI/pl98XZzvX5zwePXdZIt6OmLwPR7u51qShTVApkbOIdJfH+o1Swxel199LxN8TXco/8zWW+fCtYoYZP/E/rIKd7+ND60JIQ7bS3VBLum0vTvGz9s7Z3zgggJjnLRRfz0Mjo0HUHdQhfrsygmvDzXjAG3OgfYKpQGoKUNRToCUbDJC0yB/fTxSGpq+Q==
Authentication-Results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5479.namprd12.prod.outlook.com (2603:10b6:8:38::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 07:42:49 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 07:42:48 +0000
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
Message-ID: <ff6d11a2-2931-714a-7301-f624160a2d48@nvidia.com>
Date:   Mon, 2 Aug 2021 10:42:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210801231730.7493-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::21) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.206] (213.179.129.39) by ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Mon, 2 Aug 2021 07:42:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ea5c46c-ea02-4f7f-e067-08d955892008
X-MS-TrafficTypeDiagnostic: DM8PR12MB5479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5479BD28097771CF7BBA3A21DFEF9@DM8PR12MB5479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qoYTsmQ95KlrKP040FXQ+MacgQNeAUmnR/lvO9krgYp9/OBfG1aFss5Pu7OqDtFJYC5PTE1aWMrZ/FOJPBSVlJlp6QhZcExoaY9XoBuGXUGMrrunzWgJOHhMEX6YUe0ivY9UccStEuY0uxsmKNtHqjpxloIsw36ASwkBD4ZC8SvAaa1E9FQzCzN7H17atEPGcT0BwYI3ik8y6/a7hPuEscRuKaqr8OafsbAzujv1peAWqF/RbcjL68V3gc7FCiLjilSE+ucA9bbBidnYfMBYhDKKOyWGkx43FfVdz4MbIrJxm8/OB72UlHa2JMbOuvDC+tL6sbr9Zh6kQdJMUf1akXLZgTQoCvtGAtJvrHl73lEQtHboly8d834IY9s4KliI3ic7Q5OxPctkiIbK1HUFvbUD2nfrQnRz0tC2YHTNwZ83ewNQ5VnO9o8KiODDoFYXjKRmjJGT+uCeADLL18kQcA48nFjFbHcHjmM2yEMxC5xGP46TgiqvML0MEta1wCt8yB5/d3SwCAFOCoiKmgJktaYUutIVeyRSuw6HJpM8uIqvsli4fu22ejnbnyL0uK+skJo8Ka4aEhm6zp4U/2fpmctf7TiYEyRbivsqw7vVS0HSiWdjyJuX4YlvIAdkMLy/mwrKrhaEdoi6y3GvGaYNovtcSk0EjZRzcg7iJot7E6phWgHRUOZbJ3e9i4VkcW0wupM2rOwHgZDIX8S6L8PbP/6cpEHYBwzhCNuOb7Klu5M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(316002)(478600001)(956004)(2616005)(16576012)(8676002)(8936002)(2906002)(6666004)(38100700002)(26005)(31686004)(110136005)(54906003)(6486002)(86362001)(53546011)(66476007)(66946007)(66556008)(4326008)(83380400001)(5660300002)(186003)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmNtMDAyajU4VkNwYm4rOUJEaWQwOWdYcWRpL2NVaTc5M1VOZUxTQ0l1RGUz?=
 =?utf-8?B?bzRDT2NWWjJGQ2FZRVFrcG9qRXVkaDNqdTNTMDFiTDVMWDlkUkk4dU51dGw0?=
 =?utf-8?B?ak54RkdvVDVrLzgyOStLbytIUmlRSVRiNXVlUXE3Z0I5OGxudzZhV2pwY3hC?=
 =?utf-8?B?dFZPQmpZTXBsbVNaRmFOa3JXV2RXNUI2L1pxQTM2WWozNllTMW1VRDltdm9y?=
 =?utf-8?B?Y2h4c01GaWFQUDNEbk9oZ2toZzhpdDZsRW92enMvYkk1aTZqV1gvbEUxT212?=
 =?utf-8?B?Qm16Rml3Y3ZjQVB0dGdWQ0o3UzY3SllKM1RDUzRyOG5aV3gvRGkzaEJIeGJw?=
 =?utf-8?B?ZzBua0xZYjZkenVzcmNONVFqdE5DNy80WjNnZlYxelZ6S01xQ01wZVVVSmZi?=
 =?utf-8?B?SEdDN0hnMkVZLzNYQ1g3Y1JsSkVDalJnM0l5YnphQlV5U0NYbmczWG5tV3Z1?=
 =?utf-8?B?RVUxeEI0SHR1TUlYSWpwYy9kWEV4T29iQ2VaeS8wNXZsWWplY3A2ZFJwQzV4?=
 =?utf-8?B?N3RyQk9YWVA5eVhWMzBuYUVQNDNvcjVtbUpsVUNNUi9ZSS9QS2ZDWW8rUWhu?=
 =?utf-8?B?L0MyemxnSk50ZTlROGZqZkpQSG1CQlQ4ampDT0lYZ1pScjNPcWlmSk1BWGQ3?=
 =?utf-8?B?Q0VIeENNSE1JYzArZjlKOVhCZU9hMFFUcW9ObVhkY1AxVDVaZndQdWFjdnRZ?=
 =?utf-8?B?cXJGZFM1T1J4LzM5UE9NYk44cEVkd3BsazgxSFVraGRXNUZzNkYxWi9zU3FP?=
 =?utf-8?B?VlVQa3djS25vR0crajRvSnFmNzlnaU1NN2w0bEZJcjVJaG5RNXJJa0tKUjcr?=
 =?utf-8?B?SGhRbzlkMkczMXhGbnNmdUFubmIrU0tIdDRuUys0YmVjelBNakpLbmE5QU40?=
 =?utf-8?B?WlFRYU84b2ZDNXlaeGtLL3czVVFKaFQvbGRuNU9YaW1veFl5TEl3K1JGV1o5?=
 =?utf-8?B?KzRpVEhFVlBwbjJTSlRQcXE2cXBqT2srcCsxYjRGSGlSSTRuQXFCU0xUZDl5?=
 =?utf-8?B?bzVtczJTZFNpV05XeHhDUHpvMnY0aFpwU3VxMUpyeStKUHQ2Vjg0dk84ZVBI?=
 =?utf-8?B?clhHN2xkV3VqUHhIVjBhUlBmcTNXbCtpZzJkTWNWV1ZITUtKOG96Q3RpSXJZ?=
 =?utf-8?B?S05CNEY3SkJSeHM3clp2dGpXT2hzS0tjU1Z0WkVlVzRycTJBelBpNWQweGR6?=
 =?utf-8?B?eWRtNVpyZEJPaVdzTnRaaDdZaVBoelVlSnJCekQ2Z3hUSGNsYmR2UlYxa1Fl?=
 =?utf-8?B?MHg5QkJaMEwwSFpsay9DSTdzNHdaSXo2eTF3ZHNCOEhIa01qVXBna2dsbFZ0?=
 =?utf-8?B?eHF5Z3E5VGp6STVYaGRmT0ZIZHJENFA5WWtuRnExSVYwU245VmhzcHRpdHd1?=
 =?utf-8?B?Nk93bzZGUkpBZ0lGZzkyc0xkald6aUl6L1E0dTVacExTRnpPQTE5ek95TjVJ?=
 =?utf-8?B?WVgyeEJSUzVBYUJqOEdBRUowaHRuOU1MaGpwdFZBQWFhYW1CVncxU21jem5q?=
 =?utf-8?B?SEZlVE9Bb3MwRk1RTkxJTSsxbkNESmRRcEE0SzhjelFZY3dvMVJXKzNLZmJ3?=
 =?utf-8?B?c01STEZaYmZmNW9UT1RnZ1pyRHVQT1ZYNlBTWVo2TzNjem1wNDQ4RW0xaExM?=
 =?utf-8?B?MWY2bGw5VnQvYjlacFJud3BzYnpJejljNzJuV3hya2dMVGtxZkJmOUpTV0xB?=
 =?utf-8?B?a3lYV1JJOHhUTHlOdThMWGFJYVVoSGNpNkVHQTgrajhmenE4WnNvemhETGw3?=
 =?utf-8?Q?ezUw/mlLcuQzCDCGf7r35B8SQEgzvlfsEW0WOsL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea5c46c-ea02-4f7f-e067-08d955892008
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 07:42:48.8726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZZRF25aBniMK8G5FCLGNqIgyDlDEQAFrXo5OCywEFx5djrIRAZmGxBT0YVwHl1ipCYmKvzhDtbC/mcWUxXIIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5479
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

Not before 52e4bec15546 though, the check used to be:
struct net_device *dev = dst ? dst->dev : br->dev;

which wouldn't crash. So the fixes tag below is incorrect, you could
add a weird extern learn entry, but it wouldn't crash the kernel.

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

Please change fixes tag to 52e4bec15546.

> Reported-by: syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
[snip]

Thanks,
 Nik
