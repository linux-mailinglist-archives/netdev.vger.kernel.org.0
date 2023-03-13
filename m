Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3E96B7D76
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCMQ2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjCMQ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:28:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2131.outbound.protection.outlook.com [40.107.93.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E766179B04;
        Mon, 13 Mar 2023 09:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOLEpET+jTSUrNz2Y6b18doXCAwSsFlHE8A5vm0HNe95TB2xHwxEhdZvoKGAkdQRX2TjiMwdgHsWYpDXgB4Pvz39xe2ETJnpG6uaIoOu0/HLDMLu5NCh23wX9lEp9UzMd4KSZvTglCBaIPTl8E3lAkPj9Zpa898CbnRtZShg+BAjBtfduw6tkBX4GS7uUXd5fte9S0FUtrBccSXpGuI2PUBwjud6ZfJF2QhDZfA5pGefe2IQ+lhu9zRp7fmz9Xqi6NVvnCkOoGiI5GFenF+cxK4/UzVsUR55gexpWsjpuC0fhpUjOZ0A36PlV/6AT6WAj46FfD3VZTQ8yNkKHYohGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ahs0Xx10N1RL+18Nhjoqm1viFgySvlkCFuXB4qyYxBM=;
 b=IS32djzbDjZD6maZ3VKrqQYOeIjm80vK24fZOx0xMAWOsog+MZ3yY3mHsxspkfZopIbqOGqVsfrrQN2IY4fk3XQdYB/H8DJIlhmpZN013+BpGcwvQuufADdaGIikd3b0hAXf16g27zizP8WghaF2RQ+su8R2141sU48psD37I/GC/ZnXoNUMEV2fKJaKGMb7eZYb8hHWD/FKxg/t9aXAgrxg6eojaWff5r64toTSe3yjr+Lftcyu+SJoGuYlgf/prWYPqxHC89rxxpxO9Hss2C/etINlDeGbW1WW/ZuEk8QIR25gZ9aC+7m3kQ5bDD4VdjBf6OSklK2IJpTPZFNqQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ahs0Xx10N1RL+18Nhjoqm1viFgySvlkCFuXB4qyYxBM=;
 b=rRuT7KMBDK9LpnwqNOR54pf3OGdcDdaJykrP5Z6xuul9PU1yxkJnjOyzmvd7gmTjd1WN49w/tli5La2j45QAKRgaHJ5Rm7VO65MyFI2Uloex8Z9geJa1IUt8b7wtJ36FXtZpkMIlX55GOed+kxWv4QCTtJi/eRzgIT2NyxQKeSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4936.namprd13.prod.outlook.com (2603:10b6:303:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:27:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:27:34 +0000
Date:   Mon, 13 Mar 2023 17:27:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] net: samsung: sxgbe: drop of_match_ptr for ID table
Message-ID: <ZA9O7rFwjfmtVomx@corigine.com>
References: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
 <20230310214632.275648-4-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310214632.275648-4-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: AS4P195CA0033.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b77cc25-7e13-4194-a9c3-08db23dfd9a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: psPMJBU6W0+Oifthl2ndY6Zvl7zq8MKTTlxZN0RSwX6wvAwDqEOnfAtpvdzF7j9vZzf0MzrcnE1KYrSYKp4JAWJsUzxsOYuB18arEoq/s/zVaPJIEMhxc5CUx0DDpUUhYKBHFDj6O43wVFuKlMr3DICjCKwnRi2Eu+x7oAaQf6Qg5VBkkdIxs7qZh+eJ4nJszz1nyB5hjf0fdZJ7CyfUJOYjoE1AWLM9bIKNDHe2hn//A8+BJpvOH+oGWK9fzg9Gnc3DA897RKuSa31vxO9JbuyhzpE50PlnC284Pr2DYQ8cJev2z5/H4MRcMcZDdId4EO1ctxc9apOy2kyAi+lig7DfEIsRPoESaZbuUlWVx4Xq18KsmweN8x7U3IhjTLmFH6GoOv7CvaVce9HGQc6+pFk8dhVs2G+ImMXSKd7WR1c9mkJLY6ko+Tg0vdEMbe30tpmg/glt1dgJW8THJIvI08ZOLje+vgtxkzUL/NmrBVljnNqSXTjZoYR6oxI/XBuT+haeb7cFf/hJjoo/2I94jTYCb3QqUGB8DVFZz6wkQR0yU9FKUwoJbwBklb2bPbASLSLQHRsQ5qT25tLMR+57nXU1ZDgUQD7X61CJM0A/uhnWrmU0R1HPGTsuDmwENu5/4PYIFW/SlueMc+JO1xOz7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(376002)(396003)(136003)(346002)(451199018)(54906003)(41300700001)(478600001)(8936002)(66556008)(8676002)(66476007)(6916009)(66946007)(4326008)(86362001)(36756003)(38100700002)(6512007)(6666004)(186003)(6506007)(7416002)(44832011)(5660300002)(4744005)(2906002)(316002)(6486002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWU3aW1pR3o2TkM3eERrMmJtQjlTTHJDd081MlE2eGF2WkNiSnRvV3dBakhN?=
 =?utf-8?B?NWFNN0dtWXNnMW9LL3FVVW9aMDZ3ZXJDNloxUEtaa1p0REJ4TmN3SThOWVBr?=
 =?utf-8?B?M1BaeHVWV3c3bXg2VWJIdEZwQXZkam83TUN3Y1RjSFhhSlc0TitXbW9oR25F?=
 =?utf-8?B?eVo2VGxZZ2FxQStMZTd0NVkvYUJidUlwcmhUOHcyR21GRUtacHFNcitsOTdH?=
 =?utf-8?B?ek1wNGFrR1FYMVl3Nks4U0xTMGhkTm8wRFR4Z1NSblpVOVlpV1hnYWE3UlFs?=
 =?utf-8?B?R1pGeFVlRmhwVGFrV3Q3UGRzbTdCODB2ZzRJbitGM1JwQk9lemV5OHR5QXRG?=
 =?utf-8?B?Y2dQdGVpNlkvS2RkUDdCQlVBVUdBVlRyZWNxckR4S05KNlJ5blA3SEtUd1ZF?=
 =?utf-8?B?KzZIU3dEY0h4RkEySWhyVSt1TDJ0aUkrZVlVb3JTTGJ5STJGSE8rbE5CbjJS?=
 =?utf-8?B?ZGNlQXhERUpXSnc1bVBYTWZXNVFlU1dsT2NkSDBlZ3pHNWl6TS93NGZFS2w0?=
 =?utf-8?B?TmlsK1hUdGlPRjdBbFVGckJFUWJGTjRvY1k3TVFmTnBmZ2l6OHRpby85RnEx?=
 =?utf-8?B?TXQ0bWZWL0RGamFSdnFpOUJNOWZLWmtZaFdhMWtlNTEyV2xIUU1rZVdXQW5i?=
 =?utf-8?B?TGppZzNuWjVoRU4yTGFLNHFwc3oyaUVWclR2NWpGbHFXQkZvMlEwTDN6M01I?=
 =?utf-8?B?WjYreWJVMGtteFlqNFhDelBNcUhDVExpVjdSRVhRQk95dDg4UVFuTCs0clBw?=
 =?utf-8?B?M0VldHlSaGdmZWJVOFVWTFFIMTIyYjI0eTdpdUJhdTQvTmdtd0NNZjdHQTBB?=
 =?utf-8?B?bDRmV0ZlWG9mNGlOT1pzc2FxYSswakRQT0Z3d25XNHBwVGd6Y3RSWjhiK2pu?=
 =?utf-8?B?QUVFejRtQU1BcWJtNHQvRzRhUVJnSDdoc3JKbVhiL29FbjVtN3E2OS82QTVC?=
 =?utf-8?B?M3F1ekVGdk1PSFBuR2l2b01Dc2JvZHpwbWFieWQ2SEd3Z1RMOGtrU3dsRnNr?=
 =?utf-8?B?QWF6RUNKNUp0cjVTTDVkUXdKeGJuRFVYdmdpZjR1TkxRb1NVK3dOSGMrWmJL?=
 =?utf-8?B?Y1ZNRC90SGtMcDg0c1UzZEI5aW9JV2R4UVg5QnZVcVgxTHRnc2FQMU9TUS9Y?=
 =?utf-8?B?bmx1OXNQZDRzR2NsK2w0Q1FzYzNHanFYVUIyTU9kOEhpMHhHL29lVzZwL0ph?=
 =?utf-8?B?QTFId3FqL3o5UFgwaktPTS8zeTJLZHM0YUhwSVl1MjlsODE1eE53L1JQdjNY?=
 =?utf-8?B?aDR2R2FFMHhRS2dMRlpCaUxmT3VXM1FkYUo0NmhNVEEzTklhUkxkVjc0ZEtk?=
 =?utf-8?B?OE1JUTBVTUFhNEFsR3NSQnJEWDR5QjBYUGMybTRKQ0lwaXdJRnN2djNsdEMz?=
 =?utf-8?B?SUpsd0xHTkhMMGlJNjBacDh0cEFPSFZxVmhIZWYwNDluckIwMDdLWHJBam9W?=
 =?utf-8?B?SERGNTVPTHNiMklINVV4V0JReXdUcVljdWhDNWJReEhuSlNTZWVkTFRFYU12?=
 =?utf-8?B?NHNRSkMyNEFSak5UYzI1eEJIU1RBeDhxbDJrdDNZNW1YMHk0dXBmd0VsOE5V?=
 =?utf-8?B?TXk4a1ROYTdhK1JtcGZWeE5mclVvMXd0NDEzc0Ywc0o0SDFoU0NBMmNyOVM4?=
 =?utf-8?B?dGhFMm0zSTZwWGNiNW80SXYyTCtZekh6T1VsWUMxSHNqcDBscDZRR21pUkdp?=
 =?utf-8?B?ZFg1Y1ByZlpRcGlRa1ZyWmJaRHhKYzlKNWF0TVI5bjlsWENFZEYzZlJtV2Na?=
 =?utf-8?B?RGpCSEtuRllpSEdxeEhlRU9rUjZ2OERDZWRTU1RLMHBKR09zRVhpNGFVZ05w?=
 =?utf-8?B?L2dWR09KRGhZOXdrWUowNTM1RkNjU1JOd2RUbVFBcjJTMUhZMTVxSEpBTkhC?=
 =?utf-8?B?MWVhczhZUCtiYVc2S2h5anVpYURka2pPQjJrZEl5eGYxSGlkYU5UK1J4S3RE?=
 =?utf-8?B?TDdGVXk5alNRUy9RZkxKWGRKOE4yeDk5ajRBcklIVk9IOWg0eVdqc2lidUxt?=
 =?utf-8?B?VlZ0Z3dBcFBramdYd3d5S2NOOFErRmtVL014eEwxbVk1TmZmN1JONXRaRXNQ?=
 =?utf-8?B?UnBIZHJjck5SQXR4MGpOS0hJNkdvY2YvU0tYYmxCL3RqeFFQMCtUUDZCV1hZ?=
 =?utf-8?B?a0RLaFROWTMrSzFxdU5nOGFBMDVRK0NaamRwckpFWFBzcXVWendQTGpHZllH?=
 =?utf-8?B?azJReWxTNW54MkQyTHNXbUhBT0Mxdm80dml6SGZlQXpSSmdZc0M5QWs1YzY2?=
 =?utf-8?B?ZHQ3Z3QrNkd2TXpxbDBGbHRQakVBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b77cc25-7e13-4194-a9c3-08db23dfd9a1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:27:34.0705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMIJy8aaXuD2u1KgpinnXGZS1lYv6YXdK9uAFOEdWxUm0ls6XoWDDSD+90tpc+EH/xhysZlq1vVEXzHNnOxunHGnTb8mIZnQsnL2yf6FEeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4936
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 10:46:31PM +0100, Krzysztof Kozlowski wrote:
> The driver can match only via the DT table so the table should be always
> used and the of_match_ptr does not have any sense (this also allows ACPI
> matching via PRP0001, even though it is not relevant here).
> 
>   drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c:220:34: error: ‘sxgbe_dt_ids’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

