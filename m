Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682F56E3308
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 20:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDOSJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 14:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDOSJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 14:09:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F552107;
        Sat, 15 Apr 2023 11:09:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUFq55TH3LlE0yybUzmZi8jDjZZ1ma6zEM7aPIZs8AsyzvUNkyq7wlo+bnJYP1NHjnFlG9TO7/JSgWvfrfafzC4tYx6LgusjFBVKBEqDZva6pHxiu67BufmTxK6bhj4IQPsPvy1xJsnOiA1j1WXG7dtDhqXEbJpdlmHPwMMMHQuSf5cx2F8j5oQi9XORKNrAC4SzlKUnP9LzBz+wRXHhm+j1f+FbmFm5OM0p3OFT0s/Fh5gJawn9+9qokR0v7TX2YorSxoPZm8Sn+0ZK+VkbL8AnSiEJzbT7f/s9TLAHPgY8eV0vpnxv7C/DY78Fqji53KrAegL2n/qU/i4NMIxQQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0MnB1RlfFZL19VJytgQZonFmdf3OqahFVUTAXbEr2c=;
 b=lK8IMFxQ8dV4OBAC7YyS98Z2RWxHbpMGVvnqmnf8nGNpJ8ktBWm3I/KXZSRCVs7lBfC462Jivb12w+67ZIzvHIUHRyJaNqeBAhepfTMGkYqdU+HsQ6r2G/pC6IQXKayAf/4UQfONH/DjtN+iy8DuYquaLNDOtFKbgniF1BVRpFSe/ALgU6ScHHkGOXmI+53UjYpgF8bkNP9T1AD+DOkP3L5jI+9/KHEUf9wD4wejFfvAS9/OknmqTsjRezgRTudEqULEQE5bf0PG+Bz8RMFPJNfGAXa18hzrPr/K5zIeUNySQ6N0ohxVkFD/m+aXgjhRoeSHpOQw0+t0Pv/w3O54gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0MnB1RlfFZL19VJytgQZonFmdf3OqahFVUTAXbEr2c=;
 b=WKJsJDnkn1IKpLR1P3OFljsMDZgauIpIzEIVn+xlVGz2Kmyg00GC/NRFvIPLEHTWZInOiV4zwtdU5mUI9bAgIux+IDxZATCE/dXlmJWFwWnlwZResWbVexKoslm0ys7AQL7/rRXNjASHIpAdiz4GIDhCtzYGfU4XnXHrGNLJv4s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8947.eurprd04.prod.outlook.com (2603:10a6:20b:42e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 18:09:40 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 18:09:40 +0000
Date:   Sat, 15 Apr 2023 21:09:36 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] ethtool mm API improvements
Message-ID: <20230415180936.lx7sw4r3ungcl7w4@skbuf>
References: <20230415173454.3970647-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415173454.3970647-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: FR2P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::16) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8947:EE_
X-MS-Office365-Filtering-Correlation-Id: 76a4afe2-1ca0-4a0d-aad0-08db3ddc94d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /pju1re7TS/8o0BrZHgAe2W2GH9U7DGhZOBTgJfJVIrKDLiHjTDAdU1fb3VCUjj2nzgDSA9lPfyGbM4PMx0Kn8pdklTNYpT9deI5RSPItEhxFsQroYFlBOyzdcCvEUz9Kgw68aTNy8njrPw80aXx9tYrLu1xsqEj4mBt4ZhxiiMa04zrgAkY6iIBYFknPkQB6jPvhp72wR36/NfEFrx8kC4A/PmhHRiEfOoDcu8NQVMMUUdW4o4WIBlfEEcAlrLToWfJqZor9OtibWFuLjOuTwVYkSo+4MwkFA80f3FwTXXrcFL7Mo5b3XNbR8SjzJJl4wClFSoinNk+sdrefbF149nQy2+yo7OMihjUeKFGaWE5gY6Hn9BmePh0RjV3SDD0OX94lXEyDZ1sYdvmUXVkGw9n1ygiKjSATTGPd3Jwol8/i5C7nVFF57E3dBiItSknt+49Z6VrwJkkkezMbPibJ26LDi//DHEDVXC4J4/6F/QyY077wnrVAO3bbji5b+pBqLzdQyaPO6sRXvO7QzKZa79fpxBBRcjtja0pWy3EMWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199021)(38100700002)(5660300002)(6916009)(2906002)(8676002)(44832011)(86362001)(8936002)(316002)(4326008)(66556008)(41300700001)(66476007)(66946007)(966005)(1076003)(83380400001)(6512007)(186003)(9686003)(26005)(33716001)(6506007)(478600001)(54906003)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H2hDOM7pgi57Xa6GizYJkIfqNb4F9hvdhFx1BaYcKAYiUnL3qkt8QrymKMq2?=
 =?us-ascii?Q?XKG/1yuzwop2Nq24Vp38a/4+Fc5AdLWM8QzUz8uoxRpcvUsRg4gefGnua65d?=
 =?us-ascii?Q?IMqeV4J0MG8yhJGfKpIXA3WGxCkn+8fbckP+t8D2htqaqODAHdhi8NwpqMH8?=
 =?us-ascii?Q?Cq4FKWpKtpQBOChSaXYjHUsNgBe5WDApY2GpJ+QgZsrCMfPsr+dZNk1iaBdu?=
 =?us-ascii?Q?lal1H+HSD/fLXe3Qz1kT0YTcFWLgV2Tf/wIFshD6nlPAwPnsKm0rFlKc2q9P?=
 =?us-ascii?Q?W3wex3bB79paL2XA4zO5UZp6G0BSRuOjGa+RooAZIdGoFZ9xAqzICAf+b/px?=
 =?us-ascii?Q?N/NsWycbbp8Dj1ihvy2D2DWnXZoMyqfiUmorwaJ8+sZA9IFPBWycRFJ20b8E?=
 =?us-ascii?Q?18kjYdP11/jsuHD2BlSClT+KjL2KZKOfFuGFbAjlqLUDLaTIvHPpF1AcSqT0?=
 =?us-ascii?Q?P7m5wlPetZHhr5d3wxyoReGGpjUcw8WsQhbZzfFUIf+s6umB59vA4ySZOEGc?=
 =?us-ascii?Q?VYeXktXjoT8Wxp37jZCL0OyT4IEM6OyTFT+G4qD6kHPNPWvy8ejFPiki/UM2?=
 =?us-ascii?Q?dje/Sg+JZJccsO+Cs9BmsVlMD0XIEWizrHCjr/XlkVdVLXydoC7Hc+ZgWbgb?=
 =?us-ascii?Q?qMNchYUvkHUj8bmgoKCL6YOQ/kNyYXAlKY88+KPTi+Rtk9Lfdn+aBU1ZRqxC?=
 =?us-ascii?Q?xAwuL/QJ3HCT4prrARsiOflVQOud57gaUjKDvHAza3XleMM00nfvkzLRF8J1?=
 =?us-ascii?Q?r/KLcocMFhfrU+sNt+ziYridNDmMX6T06Ia8Qace2UZWZXz29a7FkF2UU+dJ?=
 =?us-ascii?Q?VfeKiSdr/vI8BNREQsM9V7PxotUN8WV4MhRYJSjqFL+YnQmNlSqENSklZVkT?=
 =?us-ascii?Q?e7BlRn6qPS7jASyMcs2uvUkKOH5KxP2pekMIt04o/8NGFQhjYqBLc6VzJ4RM?=
 =?us-ascii?Q?ErFH8LRQY/BA9tVJmND9pIpPb1gLSCB1D1If1OQp9dIXAiKAUWf8MGgjteYh?=
 =?us-ascii?Q?ypYEqXpJ2wKCaePJ1hPhZ1hrFyUdI1nHsldqPjjn0N6ktqXIMyX/XHGf8jX8?=
 =?us-ascii?Q?jv72ITMld1XExEzBs+Cu9O3fBxY9zkOTo1HsR1dc/G/Pn+QjilDeF2kUvYgw?=
 =?us-ascii?Q?HTkl/++jyGgdtBfDO4+B2WMaGdnYL4Cv4Ub9/UIr0CuuVGVYtrkM/IyqUeGF?=
 =?us-ascii?Q?gKiwa9NUTwn1KsEuACF6BSI4u+NfhsLT/T2Yc4KygML9jDvmlBkuTj7CONlQ?=
 =?us-ascii?Q?YPOJQUhEgVyu84pujXNep0G2ZZv8gnsjXHN//t0Qvyeng6c8R5xZHrOwI2d1?=
 =?us-ascii?Q?Si7oTvJ1M/C+sGJBYOEZyV+Z40zseWMN6E5nGCR5WWK1tpoTIugBd5kFh3w1?=
 =?us-ascii?Q?k4NHI7IDYTwQU/9pver/fEmayzUBvSWTVRwGTU1re4D/B7kEisA/nCpnNhW9?=
 =?us-ascii?Q?2Qxve01SpFayJ7rE3RMV6XVqA5LSfFUgVWrFIl/CrzNGm/rQwVO+k8TxwsNx?=
 =?us-ascii?Q?QCCOfM9hGEpgaDC50b0S++bImozNFhUli1Gsvk994QFZg5ahM0vxjJmwf4gr?=
 =?us-ascii?Q?UByJlzEcfs0+s02SiJtS6U4Ea8975eKRHqlvcnhUDRPbTrP0NOHkjoQaJzqj?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76a4afe2-1ca0-4a0d-aad0-08db3ddc94d8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 18:09:40.4651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QiTBg+kje+GVtCtka7ZjCAU7ieDeWJ2MH7toCfa5hmk70gnwzY66ygVyRSU6aTB5RqwR94A1KR88nk03C8jGYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8947
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 08:34:52PM +0300, Vladimir Oltean wrote:
> Currently the ethtool --set-mm API permits the existence of 2
> configurations which don't make sense:
> 
> - pmac-enabled false tx-enabled true
> - tx-enabled false verify-enabled true
> 
> By rejecting these, we can give driver-level code more guarantees.
> I re-ran the MM selftest posted here (which I need to repost):
> https://lore.kernel.org/netdev/20230210221243.228932-1-vladimir.oltean@nxp.com/
> 
> and it didn't cause functional problems.

Actually, it looks like that selftest passed by mistake in the
configuration that I tested it in. I actually get these failures:

~/selftests/net/forwarding# journalctl -b -u lldpad
Apr 15 18:05:10 lldpad[705]: arg_path "tlvid00120f07.addFragSize"
Apr 15 18:05:10 lldpad[705]: arg_path "tlvid00120f07.addFragSize"
Apr 15 18:05:10 lldpad[705]: arg_path "tlvid00120f07.addFragSize"
Apr 15 18:05:10 lldpad[705]: arg_path "tlvid00120f07.addFragSize"
Apr 15 18:05:10 lldpad[705]: Signal 15 received - terminating
Apr 15 18:05:10 lldpad[705]: ethtool: kernel reports: TX enabled requires pMAC enabled
Apr 15 18:05:10 lldpad[705]: ethtool: kernel reports: TX enabled requires pMAC enabled
Apr 15 18:05:10 systemd[1]: lldpad.service: Deactivated successfully.
Apr 15 18:05:10 systemd[1]: Stopped Link Layer Discovery Protocol Agent Daemon..

Please disregard at least patch 2. Patch 1 is still perfectly valid as-is.
