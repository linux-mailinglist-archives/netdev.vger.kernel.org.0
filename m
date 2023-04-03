Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563866D4CAA
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjDCPxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjDCPxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:53:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2139.outbound.protection.outlook.com [40.107.223.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1503A88
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdLrXcLzh+ZQBf2whfDWxW6Ugdt8Bquhf7j6Vmv1QPqmD5y/O+WrJy46YKhXG/hp4ukMq7iwbfIApKRLiARuP9vbIneEsWx6GdNeTTePxqLZPklHrESsmRcMjZcu2ggXHwGAfH5wYqpdKxZ7FERtPcPhwuKk4aQwv3bBjHePvdAvCtJuUJVLHYnaVatSdSbISOXJ55CehJyBTTdtvbOnokwUUGKxarbauXmSNV4lXvdm2zGReBXRq3MD1S5oJ7Xmkis8DQH51gd7qs3m0stVXYvZhKtcAy/VHhSNdpU2ZVBySjikB1URwYAoORo6SmUix00CiZWoh6S6kLXwgGruLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvJQdFTLIKSco2jW1ZJF92OuNP24xknmG5GhhZq1FvM=;
 b=bEH+BaQVgTypP/S/lGcHmBUkWAxZhdtbCEDN4XZURFm6kB8BTFDinOl+m94Fs7nvBHKe/PiTwsJkTYN9c8CVo4mmyx8XYys7fGE7jgytrzRdEBe5ucA6BvifrwFMsApFCtrsz4CyRgFT3Mr3iBPIA6/EGp/9w2p1Ae9KovPnditi6cj9cEEclDu14ItaGIaX3n9vWS5VYCJO9rR8R/S8hkhy8znh2bX7w8cJ2v3tOW2l3eSXJF0RmpjJeMe8qPakhmj6dEmx5T/qYjh9GuQBgTRuu03KJTnSwE9t7jyf4gsfb/UUzmX1pXkB7ldrVEHQLUer/wWeP0Ts/TYxSgxY9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvJQdFTLIKSco2jW1ZJF92OuNP24xknmG5GhhZq1FvM=;
 b=khSK2MCkwl9kGhuZWrZ4ViGSKsMnx4s7gRkyPk5hGzK/hr3ti6kFPuae9wfoOfiQ3JacgPoH7EsYRoDF8pTiIvAMZ4jGK17N3eJmzkOEP8UaKO6u6b+RrFROja/Lr2kKxJ52W6YmuKLKq2PXw49w9FueW6tk7Jxh/eJ9SwJGOKA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3719.namprd13.prod.outlook.com (2603:10b6:610:97::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 15:52:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 15:52:36 +0000
Date:   Mon, 3 Apr 2023 17:52:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 09/11] net: stmmac: dwmac-stm32: Convert to
 platform remove callback returning void
Message-ID: <ZCr2PhPHUyNUCthE@corigine.com>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-10-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402143025.2524443-10-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AS4PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3719:EE_
X-MS-Office365-Filtering-Correlation-Id: b2e1d979-ce51-4aca-177c-08db345b71fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IT8DZX4vPuatTa5/aqgyaaNVfR+YftiKtAaWBuY4LddQg7uoaxp4s1JVK4GpBpPTcK1g3z1NFn/3VJQSMe2FDcd9mcyQ9sv5Igs/0qKxoOLzbg+kJsdW3hLKClzsP61VFhf0lhVYhoS1cwzYORzC/IwGw5moxIqWjMS0k6UuHIHTs1Rwu7K7VLTc7OXdj6f9P48E/NSql2VFFnF1tj7kUUJPhSNCQzxSXiamIzvFRFrc3sTY/rQOwnNDAeTL800bR0VGgoNaJZdzBY+y3D6csC5eUXV9iGdnen02tJgE+sm32+K4huKd3zopjN3UPwY4Rbrp1rXIG/3FwKSs1WuTNPhlrDf/V/liey1Bw5Pvw2njY7IBzc+ZfmnT3aUKkeyikriX7rQ9jlBM1bne61SLsFA2McHq5+yAoavkhLq9QmDPI4cwJOI+j5nbnW9YL1PgfAzJT+aJFdG+/mwu7luOIRqrtkWacBLSQojvg+AJ6mxLBjE/7WCaOHONXtjvxIP74y8/Q2/yA8UbWam4cWV38IuwJrVjeJN2AHcyvDAuGzW0P2fz8546MIPMT6k8PBYE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39830400003)(396003)(366004)(136003)(346002)(451199021)(6916009)(8676002)(4326008)(66946007)(66556008)(86362001)(66476007)(2906002)(41300700001)(316002)(54906003)(478600001)(36756003)(38100700002)(8936002)(2616005)(6486002)(5660300002)(6512007)(7416002)(186003)(4744005)(6666004)(6506007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW5DTDgzTjROYjhwU29FZXBkWGQ5SGFoVW0vNThrTlI2bmJibDJhV2hBb3l0?=
 =?utf-8?B?SmtRVXpydkYzMFgzRm1SUFphQzRVRGNZK05UUGVSQTdOcVhmVkU0MEVFRHVW?=
 =?utf-8?B?Tk1VRkdKUEpBZy9xcXBFQmJhZVpjM0pNM1JNQUNKQ2NodUc4dHNPaDlVVjJV?=
 =?utf-8?B?MWgvVzZCOTR2Ris2a0ZpdUlaU0tXSmNtYmUwakVHMENwOWVUSWQ3K0ZFOTEw?=
 =?utf-8?B?cWcvdjJMdUZ1bjlVeklybUVvdm4wbDV0NytRNkljLzg4Nit4VzEyeWYrdERT?=
 =?utf-8?B?WHFHMmNKTlNaUTJ4d2R0L3FDZjh4ZCtvYU5wcXVhMW0zL2NSSkU3ZEZYeDlU?=
 =?utf-8?B?VzdYZVZUUUFoeWF2ekpmRDd4ZVJPMmprK2pma0d5ejBobkNtUmdrYnJ2MTN1?=
 =?utf-8?B?VkdqNjF5azFvc3NITlhhdWhlWlphdm5obmdjL2xySG00NTZWbDIrNkxYTDho?=
 =?utf-8?B?Q2p6VnVHM2NVRzFUNzBacWV0MXlqNkxOVll2aEYyNDF4UDV5ZkEvZkdjRE1L?=
 =?utf-8?B?S2J4TmlEUUpLNHN5bFBmdGRRZStaZlI5Q2g0eW5tcWtndFREOHJ0dXVSY2tz?=
 =?utf-8?B?aTRIbktMVmtHdmtKdVFiYkJFdTE1MTJXUmZZN01xVGpYeTJ5UEh0QmYyZFkv?=
 =?utf-8?B?WVdNeWdWem4xVlY0eXFJcnVpSW5UQWhTNU9DeUg5eUc1U0F3ODF2azNGRUVY?=
 =?utf-8?B?dHJYT3JOZWtNS0xmd0VpZGNpbVcraVRpZ0tLOUdHU0M1MnBsanBQZGZ3OUk4?=
 =?utf-8?B?V0ZiNUVNcVJBbS8vOWRXNE03L2MvejhGSDVCdlhjSEErMVNVSnZscnF5THc1?=
 =?utf-8?B?K3JRcjZSdjNyT0xYbW5UL2FqSTlkYklJaWx0ZUx2WU1NZHBGVEorYTZ5MkdX?=
 =?utf-8?B?d0w1RVp5UzhqYS9kanc0OVRBcmNtWCtwOGtkdUpQODh5M1ZIb1hmNTF2Skpq?=
 =?utf-8?B?bXNXeXV3ZktXTFhuaDBxakFXejJDdGFva3NyYVpSVml2Uk9Nc05oeExrODBX?=
 =?utf-8?B?Qms5TUdsclFza2NrRVh0dHY2YjBKNjczSHYvYlljRm00UjlGTld2aDJBNld3?=
 =?utf-8?B?ZnM0YnZIVnZVWmZxLzdvTVgxVExIQlF3N2VYeEtNMS9XcUZBbE9aWXRZVC9q?=
 =?utf-8?B?dDBnUEhXeHNNUDFGMSs3TU10dnBtN2RBYlJSSDFKNUVsRXNRUGtrOXlOcTN0?=
 =?utf-8?B?bFlxbTN3cWlHWXptMGZBbGJaRWtzSndEaXhGaEZkTGxDcnQ3MUdWVFMySVNm?=
 =?utf-8?B?Qll6UDExTERrRG94RTJjK0MxR2pXR2dmVzFMcysyWG9SeldFa0g5RmQyZWgz?=
 =?utf-8?B?RkFJV2Y2cTQvUDJMOGNsTUtBR053SWMxZFZJWTdnOUo2Q3ZOVnZzU0Q0c283?=
 =?utf-8?B?Nm1LVjl5UDNsbjB5bWtvVlM1dVFRakcxYU01OGlId3F1c2FiUk1tNHJiRXg1?=
 =?utf-8?B?c0JUVFQ1NmcrMkZzdnhZV3NCdU9JS2JIT1ZvMXNZMC9XWk83OHhhQUhGMDlP?=
 =?utf-8?B?RVdDU3R1THJjZXZnMkp0cUhHNjQxL3lnRXd5QkRqeTVmdTVhM0RqVmRCR01W?=
 =?utf-8?B?T2ZaZ2tubGJFTzdwSzE1dHNIejVreDBmMzJmbklyY0t0aUZRZ01ZbTY1a3gy?=
 =?utf-8?B?ZlZnNnFFZmZFVkhneUVVbFlvZEZZWkxSQWhUNGh5UDNQYXVEaW15RDVuKzVL?=
 =?utf-8?B?dXh4RHJUK2lMUFZVQ01FUm1ZcitmNUtlU3hNZUxaOUVvYkxPT09VdFczS095?=
 =?utf-8?B?NVNEM2FZaENhdGNCSkZDN3FIa2J4OSt3OEtkV2dGNTMvbXhOWHcyTUpwY1cw?=
 =?utf-8?B?NDNWSElDZFJKUDdsQUgwckxlcXZlajFyc1JvYTR3ZGRHeWx1VXdUYWZjYm5G?=
 =?utf-8?B?OHdYYi9GRHdrWEdSZWZxTnA1WC9BdEsyaVZrdXRhM2FxS1gwSU5LSGIraVZS?=
 =?utf-8?B?YXhrd2tGUlBuTlJ6MlBrN1hNYzJyTzczRGp6cnNEY2RPRStJRzBDMktIazYr?=
 =?utf-8?B?U1crM0cyOXZ1VEoya1A2RFRqakxGY3lXRm10eU9wZUpCLzNFU1Z6WE11TS9U?=
 =?utf-8?B?aythYW96azlMbnRaR3pHcmZNZmFFOER5SDc2ZTdCdThqSThBNmJSY3kyYnBI?=
 =?utf-8?B?R0RtV3JaeXY2aXBOU0gzUldONG1oOE9VSGRVelhKNDBBTG9JMlVnUVBSVnpW?=
 =?utf-8?B?WW5MOTBaRE9TQlN6UFdCMGVqT2dNdDIyRWt3MHZhU0t0QkhBaVJTOEEzaklv?=
 =?utf-8?B?dS9HWUllYU1NV25RT05XWTlaWkR3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e1d979-ce51-4aca-177c-08db345b71fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:52:36.5202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17EzVuEYnwnQysewWSVPKhNbtjrwJtup/E0XieGhhUTDGl27Stl2tu2KHp/mtMCYViKR7It/CjVUOIuJ3dT2QQzC6fzBuKXTv07EZqDc6l0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3719
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 04:30:23PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

