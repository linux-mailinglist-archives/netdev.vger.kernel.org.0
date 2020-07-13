Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949A221D0DE
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgGMHt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:49:56 -0400
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:1670
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgGMHt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 03:49:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8m0w6n2bIlyCzBYRthGFEQlUZrdBbshWhfY4UKOURcwNx664/ySWwRt+zmrj8JFGl2MDzl+pLsvwbMIQvHOZ2957iZ3VUJTkWZsHIADhV9tJ9S26BpiTwcM06WwwY++47ODlxYA5rYynsea5N6JJjRERdiRWLXe6lxC0AspDeFWjcnJLkp4pNjWDAU/uFJ5ng2TgcDZdicoJTO6aX5+5Bic9aqwBkwQDOsLXIf6DpskfAvLc/D0WDey3KiD/N0PkeAl+lbMJagc3HmrnoGk5mYNGWLm55pqsj6b0hBgOTGv71e8J6cJXcm0ttxcmf1NKbVYAD4cL6EF6o/aEv8shQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNygnSKBjZkSmqJsbkiELX1+xsvIP2x4nPmE7T6EaDw=;
 b=KfWierXX3CBQcOWpSJuldBGzeUXjgBe7ZgsuYhivEFSU5fyxq6eAecN1dsuHVqfkdffdWN/eOhwBFIvHWC67Ph6Z6X8ubOd3YI/ky3XiMQ3bBu6CLPQInjILXKdrTNkGuR0B0mu/NPUP0ZQCIv2xyKqPXENvDwzfa+b260L5SfNKDIouAzEbLvuq9vql2KQVklNZhKmCcWerwoYmnciCb21gKZbAIj/Ga4ztQ0JUWzLrZ2E/6uWdQ4DxWRDjHdh+eFjQyPGrUIthh785Ehc6JlCtrmpaa1d6dzDiAVdy3+QUWgxeaQHVyEdceSwhUTf6vQmij1O4p8AlBl8mfUa1gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNygnSKBjZkSmqJsbkiELX1+xsvIP2x4nPmE7T6EaDw=;
 b=SDVfHEKhzxDlv+/XOqoIbf8cFq1auCBEXb7MbMIkZvqPt9gSZ/IFBddhssRXKdzPNeV2Tz2A6fHEWoRRmAMdnISz7iNb+ai7gaVZU67U+XaKAuRbTnbQ3ieaB1Gszc60ZbNmTgHKjhFNTz/SFUkXyoZEnBYFKpsV8BFy7/sOrXM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM6PR05MB6262.eurprd05.prod.outlook.com (2603:10a6:20b:8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Mon, 13 Jul
 2020 07:49:53 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b%6]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 07:49:53 +0000
Subject: Re: [PATCH] tls: add zerocopy device sendpage
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        tariqt@mellanox.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1594550649-3097-1-git-send-email-borisp@mellanox.com>
 <20200712.153233.370000904740228888.davem@davemloft.net>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
Date:   Mon, 13 Jul 2020 10:49:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200712.153233.370000904740228888.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0021.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::34) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM0PR02CA0021.eurprd02.prod.outlook.com (2603:10a6:208:3e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Mon, 13 Jul 2020 07:49:52 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3fa5ee48-7020-4eae-fee4-08d8270153f5
X-MS-TrafficTypeDiagnostic: AM6PR05MB6262:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6262910C89EC5B1EF169079DB0600@AM6PR05MB6262.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2YdROP4mGBSST709V7+LJKvPq6xckioP0eRfK1Kh3xHfNVU+tPY5kaxSUDfsUCPAtSM4IHFHWeqBDnLV+Yddg28WNqrooVXj2KyZ1sjP6KyqS/VqTk3Rj0MHFtDPOoNj54YGKGkGFLKWptNriAbq858fXUa2zRoe1qi1GUBhuZLwAYdvLsdoD5if9LkjeT3g9rYMM2+HVtkWZ/t9O6reY2yOmlT0N+JO3LSQJp9sdqAhb+RhCaW4RfLSyfn7lDXvKVTKIk72J5e8YDc8jNLwnUg4k1n/rqgixqHc7ZBYxAnGc0XyxedscFzkMN/xp6mhvgLYeW57aLkEz2pUZR2Q3qUrA3B0c/93FW+EIFMyBwpNrXQFuXHQBsuXnBVbWHoJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(26005)(8676002)(956004)(2616005)(53546011)(52116002)(4326008)(316002)(36756003)(478600001)(66946007)(66556008)(66476007)(6486002)(8936002)(16576012)(6916009)(16526019)(186003)(86362001)(31686004)(6666004)(2906002)(5660300002)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eFz9Bg36EAF/ITGqkkygJBqcur9ZsPN4F4MY4R1uNP+soXJkLj9zauqGh7yWlfWcfWoom/APGtDGk1CI0ILtKSIfFNMrieKvlcK7zUY5c333Lyu6fgAOxm9Mh1Y9e3eAFyEJ/YEfOOrwcdKF78ldBiU2pJFG6uOFZdVKVpzQHhMDGhTAsqhCAVZIxDINeJktTD+fONr7NvRd09yUfGN1zVJXE2X99RUWIJYdzeE4ijRh+c+EFElRsMrU2qbXAoF0rm45KoUb9IOWc4dwfGKL+hqE+RsrvHpBAWzZ1b3P2ie1KlsumUhi0I95K4SDJLISeGLFz/8v69CN52HULqR9ppJQ5t64PZp3mTJK1ahkwMyjLjKQmAsKIo4mcfQ/EhJBd5Og0hRK6jGQcmViVWORlt/lNNfEnzC8Pm4/m25BQ5Aj0AvlnPR6BavxgUICDps0CtQvSA1bKDo9KGnIx5hsvd1THcStZ5ApfGQL8N+BBppD3N3RW1VPIdQu+Ij1wTQu
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa5ee48-7020-4eae-fee4-08d8270153f5
X-MS-Exchange-CrossTenant-AuthSource: AM7PR05MB7092.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2020 07:49:53.1161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: isIZGJk6S44fEQzZB+iugZf5v5ORNCKAJOXFdWReFuLF5H5WKbjB9QbA/8PlkbIaZQ59vnMhqae8K8uzvxqZDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6262
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/07/2020 1:32, David Miller wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> Date: Sun, 12 Jul 2020 13:44:09 +0300
>
>> This patch adds two configuration knobs to control TLS zerocopy sendfile:
>> 1) socket option named TLS_TX_ZEROCOPY_SENDFILE that enables
>> applications to use zerocopy sendfile on a per-socket basis.
>> 2) global sysctl named tls_zerocopy_sendfile that defines the default
>> for the entire system.
> We already have too many knobs, don't add this until we find that
> it is necessary and that the kernel can't do the optimal thing
> on it's own.

An alternative approach that requires no knobs is to change the
current TLS_DEVICE sendfile flow to skip the copy. It is really
not necessary to copy the data, as the guarantees it provides to
users, namely that users can modify page cache data sent via sendfile
with no error, justifies the performance overhead.
Users that sendfile data from the pagecache while modifying
it cannot reasonably expect data on the other side to be
consistent. TCP sendfile guarantees nothing except that
the TCP checksum is correct. TLS sendfile with copy guarantees
the same, but TLS sendfile zerocopy (with offload) will send
the modified data, and this can trigger an authentication error
on the TLS layer when inconsistent data is received. If the data
is inconsistent, then letting the user know via an error is desirable,
right?

If there are no objections, I'd gladly resubmit it with the approach
described above.
