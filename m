Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD35B67B319
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbjAYNRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjAYNRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:17:04 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA15B83FA
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 05:17:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ns7MLOnNXjv8b4UOF9/4h3UR5q5rnuMmpQEdPJ1mZGX8biMZl5weR0vTurHN2xSN/dMd3ewsQRzb/WzAh5CKJTbSj1Peo2Q1SMoWgAmwCQsBJid++sjwYLJW4q0EolC2R3Y/7zxKn4afH6To+M/XQUR2m/CPA/PKtQMKadwLDEwvAPs2NLK6npasBaXFmlgVi4rThDIPlhgZDU5cklDGii/0w9J0QNhP/z1WLp1yk5du1OrKmpyqa6j0FOYQnb/2sSTf4tX3X0ut8tW1Wa6SMNqedDgJs52xteMEJcBdrRCA/Iji0D6QH3nszRprj/KTCeFoQETnylFpRSluinkpzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3X1AsfgDUAVzN5JrSrm/CHPW1FCik19t3whmIJZsxZI=;
 b=oY4W64DzBcBndxI3Rw+s6oubay3AOVlel23MAxh4wBuhf6mJhv/wP2kYc71p4SxparOj4qT+JWgm1iBdenQ3YG1DIjQA/bf6puT/2ImW5byb80EwXmZBxFIILZQam9/uSJf6eNgromKUIMy3YtJV0ObzO6IRspNb43tOpU3iQrjTVz5bf7TrQrRac1EA4Vc8leT6BPeQ72r2MT0GoBcf1/Vsxe9KGqGC/SosdKYSe54Ddp7URVWYdoZOwMoaV/ablWcUX+AVIeZHRuiofkvj2ze0JVQYM7qgHJcouR67vq7TnoS28yeUZ2qFzGA/k7tOiJ3pC4IFp4k8+K7Hl6EW6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3X1AsfgDUAVzN5JrSrm/CHPW1FCik19t3whmIJZsxZI=;
 b=SdCvKQS+LGD/oRSK5Tp3LTk/4CX8xX9iXBu2QKrs6oPSjVE8PwXND0jTBS17ypMGVeBDreSmcn7yjfLAxotdCNEwmq/+XBSxJ8+WKmYqMtM8Jy5La40SWt+rpLEgWvjr8sLX4hPwD9nlsKMLRLyi4YRddxqG9Nc+aLh8DSfhqM4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8565.eurprd04.prod.outlook.com (2603:10a6:10:2d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 13:17:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 13:17:00 +0000
Date:   Wed, 25 Jan 2023 15:16:56 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 03/11] net/sched: move struct
 tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Message-ID: <20230125131656.ebs6hwwpjleq6tuo@skbuf>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <20230120141537.1350744-4-vladimir.oltean@nxp.com>
 <87cz72ahh4.fsf@kurt>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cz72ahh4.fsf@kurt>
X-ClientProxiedBy: VI1PR08CA0226.eurprd08.prod.outlook.com
 (2603:10a6:802:15::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 22bdb971-5acf-4cd4-58fa-08dafed67136
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PsDVe2SBmSEsFUvaZszZIxD/MyqanRccXienNJeqtcNUYKkkFvUp/V/gLl+pco6tlpDrxisT0Ylzd4BIoPwX20APBgdxEmoZj5AvOhSz2oVfFPY9d8E9hRhlrAm+1p1ltR+VdDa56ZorYOX8TPJU5+P3PFWAnlUtTNhj7HSApQ7eC7EpJHg4pcwYjH9LHpx0gs7z7ySt77r8a0G1XjjaHv8aWgSEZD8uZihkbk4pw8HBDED8llzvwoDJ+n2TFvEto5yMUf4VGbbYHn9t4iAua6ZpQ7gdpNKROaz0urMsR/Z4gL4ji5Ru3tve1d57zSZIw0U291aYCwto6E/EDy8Nt+is4tnOzmbhrPs385uFf+kjFpLbi+BJ7Er6R5SRNZ4s5AAilkXgD7SZ2OkdmnH5G5HwammumPXuNdMFLXVflpljkNDexwfZ8egdLOlceKlzhqop8h+VLUWciNnrM57QPjnlVWDzv+eJN2pGL3k0WQK63CwVXjBk430mPhNIFNAduPL315IM+u+kT3tQ5pO2uNC3znZycHWLS7juyUGyOu5jDRqV6vRB0hDJMQBMeo69SmhFpybhj1uZWo0MtrkzIrw+ImvBrmqHEDyvvdBA8WmuaRH+DwV/7bTkSQ6r/dmWqsBXjpW+DcaMhUJHet+W7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199018)(66556008)(4744005)(316002)(44832011)(54906003)(66946007)(8676002)(6506007)(86362001)(1076003)(9686003)(6512007)(186003)(6666004)(8936002)(33716001)(41300700001)(4326008)(5660300002)(66476007)(26005)(6916009)(478600001)(7416002)(6486002)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gq0bT6Ji/7VHdFBZmzZ4isvyz07HqBxGt2ze6NGGHOQx1ERPmvcaku2lWD1O?=
 =?us-ascii?Q?4SaE1dLHduwBX/KufiMeuDqaSs72pV4RtcDZuE44T/5C4BTG6ysDV8+Fwp1o?=
 =?us-ascii?Q?dpSJsvCB7sxtZyhKQ/5x+yrT7hAX3S0k1oR7fLfJJVj+oYZeS2yzG3YRxuQB?=
 =?us-ascii?Q?bg9aj1kRMj8xrMGZswFgX2ICKYMTlUtI1Pj9NciHDj7bNh12r6G5iSNexVa8?=
 =?us-ascii?Q?F0DLd+4IMu0aybjyaK9zn+Usp066g6T+DajbiDomMJ9zTFJJM9zVW4eoSAOr?=
 =?us-ascii?Q?GQ5gf6PPsxHD3MIp7d6xf1+nzYsjYg14C6cH0QlreH4WZTXtGxjblX5l9d78?=
 =?us-ascii?Q?hICLJHnwQ7PtOLHSals1psQpm0UWdX6urgIFv3YqPRcTO4xtzbyTcXB/4OTA?=
 =?us-ascii?Q?G7p6eQFmWfvECyXa2FPwrgV8nLaMYDRD678umWhEeiZ7t8LMzEO0IoIDCBEL?=
 =?us-ascii?Q?hU3aDNthlrNIcy6hSmNSJ3FMn1ROeE1BUFIppVLu3XHVIYNcY7mJeSGJ58GA?=
 =?us-ascii?Q?SCAEOEZN0gq7t6XQFuzz/jaG015bWcuf00Ej11n8sCNNSj47uaWFLUEBt9LU?=
 =?us-ascii?Q?wPjD6W8dEwT62xIkG70XWVIy+0yzEkVh+ziEWM5dXVboYMAoMk5i3Dz/sTJz?=
 =?us-ascii?Q?U2iaH6AwUsd/Jly0Y3e/pjaY1ZOZvPzjEqy2MDPx9QXA8KVSyKHigxvLub64?=
 =?us-ascii?Q?i5Xv50ARCD9vO1Fh7UATt8pbcbJUFNiQNsBCzJDj9dxxzSOsDMGWDKI2xV05?=
 =?us-ascii?Q?DsWmGt5F5H9DsBdI3j7w48qoVcQKserXY/gPFsLtq5YV52RGG6ITYMKmEZAm?=
 =?us-ascii?Q?ELUB4bSEQjZuDNKfU502H1c+hsa9Y5OxTy69IGNyKmZdulrs8xm6TzcCa6+L?=
 =?us-ascii?Q?qnXdt+wvaf/PKo9kLKgkT469oC7938h1SvHivwhLDt4DIfQhA/Ps6OA2iiej?=
 =?us-ascii?Q?HVwtPCGW/W1/kkHXb6YZyllzsQCu7nbxlW7N7p1BuYDpw0xiHoAg4/GgpDQF?=
 =?us-ascii?Q?wZ1LsaPJL4/ERMzI/sU36h418fP9fJePBUEBXaC+j+sqN/LoAo5MQvOLN8hA?=
 =?us-ascii?Q?BTKpHGy8iBurO/hUoJ5fWLjlH7cOloS4wULtycrBLUh247oKvibrXa5mUb/E?=
 =?us-ascii?Q?CuVvuxJ5wCJNKRbdMGKZMySGMNU53wJp6kk70xTECxilMiTZzwNd4zjXFBFh?=
 =?us-ascii?Q?Yzz6qxf4LL0tQrasxzcxeEjJcwlo3aI59QtvFvNhWviJ4QL9IVJiJ+3/2ohl?=
 =?us-ascii?Q?N8AfNfTheq7LSOzRJlW0PbLynipjYi+CBEjFahN0riDmK+8rXmgR48bqi9BD?=
 =?us-ascii?Q?F4SwCDUSwHfRsqQg96yy+ljuLSrj5F0QXEPTPx167IGZxL9uL21lr0NnR2cl?=
 =?us-ascii?Q?hZa4H/zyw9s/ycX94QZdIPh5tLLJ3ZQHKipxuLQOnuhM8OC01No2yhsPOGwS?=
 =?us-ascii?Q?5Eo55sl+NrbOYW0GR+C36C+w5rAbN+i8wUnuN4mHT7vlgMkjKy4FCiyhvAMS?=
 =?us-ascii?Q?ZAg/zy5M30JEtRW3TJrt6jcErUeC5Wf/5SAFToFLyi34W4XgjvszcDJ26aa/?=
 =?us-ascii?Q?6NNohBA74vW3cIAqTeUCLxi0c0kln4UnAfkxQJcCUJvNnw+WpLfdtd2yY3lV?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bdb971-5acf-4cd4-58fa-08dafed67136
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 13:17:00.4377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oi5brf2T/vFZ8G76FVYO1EW43NZisDPhI3CkXJgQj0r+tASco3DA85WUTQUw14ALLvELsWxGIrnEY6xzFcTdOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8565
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 02:09:27PM +0100, Kurt Kanzenbach wrote:
> On Fri Jan 20 2023, Vladimir Oltean wrote:
> > Since taprio is a scheduler and not a classifier, move its offload
> 
> s/taprio/mqprio/
> 
> Since mqprio is a .... ?

That would be the muscle memory, I suppose. Thanks for spotting this;
I've made the change in my local patch.
