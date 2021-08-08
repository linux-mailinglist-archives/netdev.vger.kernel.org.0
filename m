Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBA03E3D14
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 00:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhHHW5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 18:57:22 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:33075
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230024AbhHHW5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 18:57:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEFqP3IbqC07Ut9hmZ6jAmYPRyikGAGcDoFNGJCFYBVoPddgr2sEPZ7+jTbe9/qbG/q6j5k96BAwRJ/70ayH6+CdmMxY2L8c62V53LcDLcKUYyt07UHvBiOnuyOI0U4dKAFctvAw1pSTs3USaZEhKZIve3B5FeYnxNS21B4UMbixCQCEPpU9bNFS8CXPMalZH+BT492zMzkiFKms0DYNU4HiEurHoXtNRW47zUgm85ki4xL78mQAT5ukNgTbW3oeLp5OjJ28dUoo7kUWibIUSMOnvpItFeEGxTsYPHA0aT3AFN9NkbuP2EWOolZ/dulDqq4o7aChqtEztkTOwXMFBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Is+LAILptY/FCCX7WIDstXjR2HMXuoUQ/6ZQyDvzSA=;
 b=ei8iynpDdJ9p9ABpIqNlAbPzJSh9Jbtvc/JUIF6gTEBy2uDSJKlHQ+QIy5ii/c4hLbZTx168oa/glOcu86YohwwnnEdPpcNO+JASJoqsnUvC1h6QpV8uudJdazv9CLj5E8tT/AQXlMpDkSrBfOFUDjVk++dkMJtmT/VUdIZmDmXuy1Beq7vc92DOHFDYV8pWbhm3ey95LM96aX4LBthDTBRuiPIymadGXrIyqR9OtM/AnQ13W37m93T2Hc8pIJZL/yHXmcq5aZmJefx5qIFg4nFFObUB4rR6RKFuh83qWuWLPLx5e008D/uWYEutWDg4CBRvYZU2OMU3VNBXtX0b/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Is+LAILptY/FCCX7WIDstXjR2HMXuoUQ/6ZQyDvzSA=;
 b=exUoCABK6kvCZHaabhS2Fe15dmA6kdQuSuZ5VsyR9/dCQWS+l+3NEHRLPWjte+MTVAb18M6p10DQXIyqOqf2DFvgXhTqHXrMprcPloY/JUBvrUbPoJhYQVEc0Ykl5xiEXql50ya91AkkVmcEXFOyeoP8LZ6J171sGQRvNDNfXnE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Sun, 8 Aug
 2021 22:56:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 22:56:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] DSA fast ageing fixes/improvements
Date:   Mon,  9 Aug 2021 01:56:47 +0300
Message-Id: <20210808225649.62195-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0015.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1P18901CA0015.EURP189.PROD.OUTLOOK.COM (2603:10a6:801::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 22:56:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f962cef-b5a7-4e05-567f-08d95abfd39b
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7328642185EA70163D7AAA02E0F59@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e31F9TQTwdfmnRUBECVg2wGLE0r/t9phXwT4KKO7m6W4lfDVVc9hx9OZ0yDzGZtguRz72Qt9+B7bo0ho0dFpa969KiuHz04TJZ421XcwNWKIjgKnz6f4tfaTpaW9ib8O03wOgv19nnf5vfBp1UCwt63EonaiLU2ZXSrcOhgjYOgbOvkCW+CzZYt56HjwRGK5wT+VWxRUP4EIslJ0WAXw6BJhRhSgxZPbFHaFEWqhutA08Aqcrvsi89D8dG6Oj6B74j1Cd9RWPY4tayPW3ZaVFJpi0lYEHJC2LFPX5zo40b5ymAo0MASsxuI9GMODCN6AEh44hBsjMOmtPlAxHKY4GCWlpfwOyCkRM1/M303LCRkR83sPkmzd6GWBuxqSfuFTKqEnsfSWZVKY+aP2fppD75lEWj1Oa0CKWlGft5jpJ+jcW19DkFAbEQvGtnGa9tvUf/dgKVkmjBALHZhQFrSw0eyc9oOv4nOgbxiQTtxZh6n+6f784d2BUF9SpvEyoWUr2YOqMFaiq9Gw92DgOW5Ac+SKqBujbVRZ0iVj5UE6Ba+UvAODb9YWGbvS3kKTFUIpzdLIBL1Cz5RHXaLreeL8ddDgJSjMMurBAdknElNAVA8wxiZTAVydGmQ5d0zFdkz5OBm9omtingfh5itN5tUsx9fmFsC35tqd63dRl1hSfb+WC8auCF2IXUz3Fg79gMryUBdV2gGfyb7csxv7LlxY2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(4744005)(36756003)(186003)(5660300002)(110136005)(26005)(54906003)(316002)(38350700002)(38100700002)(4326008)(6666004)(52116002)(86362001)(478600001)(66476007)(1076003)(6486002)(6512007)(83380400001)(2906002)(66556008)(6506007)(8936002)(956004)(66946007)(44832011)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+jEhhKj6WBouwxCl/AZHDGDhKpFWf6z8Hp1iUuzvAHlxYe4N6e2BlbFa4OSc?=
 =?us-ascii?Q?pqgkrz7/x2smBRBX4rBpXe0nFBYPfeSVnNx3EcX9/kY/YdsVd7Jxu1GyG7lm?=
 =?us-ascii?Q?9I9u/YDbn7X7/BMEQ3Y7z3comDr/gtLFFQDqRXDgVc6eHjmlpm5KXJbq7nXz?=
 =?us-ascii?Q?WpwMOzIGSCBbxgN9ucS78zd9n9X3VOIFhaffwOCTQJXeg2kJLDUec2lSnQGx?=
 =?us-ascii?Q?khEN5zxk4WhwktItFxYovDG7HLisTd8LCEbV7nUIxAfWA0d3VjHZ0mO8NLKo?=
 =?us-ascii?Q?IthJkx24ckPB/gYaWWKWB5+2x1oY4uuoYTw2Gb0xFil5dWtA2mjSdbVoovxQ?=
 =?us-ascii?Q?4k5Cz370LORGg6XngBHr3q/WcVj8AorQgCkRsuQD4Dax7r+/hOSrTdSKX8d1?=
 =?us-ascii?Q?mOLqKOp2JASSYOkXadMwE8Xsr4PPzYz/K+GCAc81FjMZpPgbJ0c8gOZAAUZs?=
 =?us-ascii?Q?/6o33fGWPI42H9jE6l5OadJs0l+4t499wy5Kt1ZSN08J04Bol7VSk1qtspDb?=
 =?us-ascii?Q?ALK5l9vFFtNyfcPLcV/0NL0imLMTCzCGTOYtzrXe0ftdIHeglaQvm/DKmM1o?=
 =?us-ascii?Q?M4MeBflhA04TnsuR77ZABGeX6jUbaERm1/TDe2c08HwwQi29irXZvZ0dkCrt?=
 =?us-ascii?Q?zCTIwx5eu4E98NDCaCBzzpNzYIVUqkgayVDvx56Aypm4QzZTzgHnAjCRxRzK?=
 =?us-ascii?Q?MuwDJexfyySFRiKXr2KkMNRAWpFn6polfKZPMonXnQ/OwFb9rxTmKAy3m5d+?=
 =?us-ascii?Q?RbivG+lOTUAFeP9V9qob9SG3q0Lbh1Ifur8NpmkjM2MWOj/l/0tqAOSIpJLH?=
 =?us-ascii?Q?/osNpUQlj8iPzxPeLVWIxVs0jiLAHtxijW6JhQ4zcUnN2Wv/6pUelXnAVk2K?=
 =?us-ascii?Q?bIt7KEJBtLyTy9I9H9JjTwRkirPKhUZ4E85D8cUsAi8wDDwj977hynODQXc9?=
 =?us-ascii?Q?AQ6KsNZuoh1IBnbjmPzEjQUI4eEb9Z0eOmEfCRsYWLZhYYACozHKv6aNsR+6?=
 =?us-ascii?Q?jtDiqkJnQ6Hra1r+j7fi3KvRoAyM0GflLkPz1dSW6AglIDWIvkmkWwtGjo2T?=
 =?us-ascii?Q?/yBw0VYSAHSziLuI9d9RMt0R3km+S1053OlRwucd5RYNXl8w5qy+OthT9154?=
 =?us-ascii?Q?ezy/P6fknlKkuzN7W1vaLUJQKoWmPzUUthy08HuemTe3cnLxIVRuav0gwlOr?=
 =?us-ascii?Q?VjTx4RleldqGIVBbMN1CZ+mzz/bo86Yso2RVT+eHzhEyGtGEXRi8OVkihPxe?=
 =?us-ascii?Q?MNEWk9wg0bBFJrNt3TGcPB5OaOHr5HiPesRPvo7k6aAVEpNKA64H5PKSTf1l?=
 =?us-ascii?Q?//0BQqJo7kmU2IL3HquZmvuQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f962cef-b5a7-4e05-567f-08d95abfd39b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 22:56:58.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGlpyBBlXQeSqBtsTumudXkxoOnQ8s6G6Xt86+inUfGIB2AfkAoJSdPyJ8p78fheK0dgsswrx6Zbz6ForRRcrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are 2 small improvements brought to the DSA fast ageing changes
merged earlier today.

Patch 1 restores the behavior for DSA drivers that don't implement the
.port_bridge_flags function (I don't think there is any breakage due
to the new behavior, but just to be sure). This came as a result of
Andrew's review.

Patch 2 reduces the number of fast ages of a port from 2 to 1 when it
leaves a bridge.

Vladimir Oltean (2):
  net: dsa: still fast-age ports joining a bridge if they can't
    configure learning
  net: dsa: avoid fast ageing twice when port leaves a bridge

 net/dsa/port.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

-- 
2.25.1

