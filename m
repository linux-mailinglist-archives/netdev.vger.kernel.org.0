Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D4A6EC179
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjDWRuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 13:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDWRup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 13:50:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2137.outbound.protection.outlook.com [40.107.93.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7721910D4;
        Sun, 23 Apr 2023 10:50:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwMsTI8kj2GPYPUsimmB34U+GSzbbqsHmAcRpzcSkjoWAOjwk4KnZb34KTxTdVOfP2G6WBT5UdNZCz9uHWzZkLcyEC/OZeuAZ6IBScz/1UiYU3sHWFSQrVVDVPg3x4gywsw8cx7Klj1DjCqOYks0D4J3CGBg6kcXrygO9YbZHGtER7tJwy2113i+9Ebbi9F+NTqO7r+oslnmIxQqf5Ka59ve6n3LJ4LD2g2UAa1iAP3S5bf0dsVCQY2oC9DRuV/kv1L9afZREoKHTwEDW4Ep536/+r34e6ut/kLpjeuIPNBefpxWAJDd6oAGzixQ4hPpCHqLem29FFTg6BQUuqxVfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCxhp09bImI7N84y+5CYCN76d16uJ/qGk4Qn7jihkWM=;
 b=dhtGrwGsrveZZQz5MdW1z0fwIoM/9anNDukmWB/UJPNKI0TMHTc+sOUj2PDCvGiMijJkyxrOmgF6twrlbQ9AuIxw+SqQWsuV9AqFTL6shZdpUeC9PD1Ur2+9Kr27b3G5gDF6pOy/b4cupkqsCB5XBJQh3qxCr1cuzZUxrV1CcXRB22XQzyP71Njxv6aNeVTV/kvSfcTre7rgv1afwMTf+YvZ6r2HH7Km0yOyWH3afij8MH7pogc5DrkWHip8rqFR/cS4igmMA3SPwdloG3C8i4smF9OuF6MYyEviCJMY9RDQ6GH+nhgEhCSYYsQGjhifLhffutTg3Fm13SCINwEqoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCxhp09bImI7N84y+5CYCN76d16uJ/qGk4Qn7jihkWM=;
 b=e6p1rvDTNkVSDd1THFIR9FlPbLhFVVXZq56EgLcvmU/7W6iRNuWH79xDVNs74HeY3LF41LG6TXZ8vNt8WOKV0AB4UgCljfcsBpxQG98ku9kxRbpuJlrEVkVpraKbH/Xmsv2snLhFUQlk4Nh4UwXZ67PbOWSwVYjEPauwqWLHZdA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3698.namprd13.prod.outlook.com (2603:10b6:a03:226::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sun, 23 Apr
 2023 17:50:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Sun, 23 Apr 2023
 17:50:40 +0000
Date:   Sun, 23 Apr 2023 19:50:33 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Peter Seiderer <ps.report@gmx.net>, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>
Subject: Re: [PATCH v2] wifi: ath9k: fix AR9003 mac hardware hang check
 register offset calculation
Message-ID: <ZEVv6Q+XnFNb+MSg@corigine.com>
References: <20230422212423.26065-1-ps.report@gmx.net>
 <87mt2yltta.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mt2yltta.fsf@toke.dk>
X-ClientProxiedBy: AM0PR03CA0086.eurprd03.prod.outlook.com
 (2603:10a6:208:69::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3698:EE_
X-MS-Office365-Filtering-Correlation-Id: 18cc71e0-2378-4610-54ef-08db442340b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xr9Asqwrf/XV47pseMj1ftbTqOUqAPMpen7jUxWGZH/dqowJgD++2N5wPBz+r692s8zXiJM04WNjPePnHsKYvY1cXBIAjLNYQ2SLbiX68ZcmoEZ2FQ7nQ4TdON0RmfBWtEIDRPf2vYAy+Qur0RUG0VC4X59EtnFMXSbuFtijvsGpHZ3MSz4KjgmnmY2mejNdQ22MLqxBk18Q789xyIlnKIjW8NFSXOVzxCuTmiHQc+JwEn7n2S0XE4Zq8IROBcflZCdG1e/aU3q/y6VcGSH83EAIev5Y9rG+5orGqWl2J5GYCoW0AUg2zH5LHj0LsEhzFtFwFqoHuEOA+pwAcl/RbRVkN24INShTDtC1dSMLt891KnIPrX7OiIUKJB9oVJnHkTvrgDI7c+DQCb/dVpFqadiJGFu0Ie16p9xweBb4VZhainspRFE+A/1BY3EMiGBn/WMymVmn1oA+QlsWUtzyddxZfxVnNddMvkLNyUkNwQ2i8ekdwh88PFDi8rp9GKkZC8HoJeKODpRTj+9IoVVLyqE76Xs+/FSfq7fQsAdEAPc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39830400003)(136003)(396003)(451199021)(478600001)(54906003)(86362001)(966005)(36756003)(186003)(6486002)(6506007)(6512007)(6666004)(4326008)(6916009)(66476007)(66556008)(316002)(44832011)(83380400001)(66946007)(2906002)(4744005)(38100700002)(41300700001)(8676002)(8936002)(5660300002)(66574015)(7416002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3ViZFd1a0lpT0s2MmRkMFRMYWhGSmhwREQvbWdKa1BCT3NYc3dNSWVJMVF6?=
 =?utf-8?B?ZmZndFgrcHNkbDFXZzY5RXZxTDZ0aFdsczQxcGNFaTAzRmIvaHQ2UmQvSzhL?=
 =?utf-8?B?N3dGQzJhdUt0NmNCUGFvYzB2cDBDTm5kZkJUTDlpc2xQeVhoM1pwamVlY3lS?=
 =?utf-8?B?ckRUU0NKeHAya1FGR0hkMUdXb2YyeWF0K2RiL2d6NU1ZT1JSR1NYUXp1UDJV?=
 =?utf-8?B?NjMrcGhyeUdnUzZXbkFneHRrdFFwalhZZDBHOHQ2dDVHVHpvdXlqUjMvbllR?=
 =?utf-8?B?SUlkbnIzWUpyUE1PeDJoUjNmczlocUs2YjdhT0V2SWpreVkwWDBqRERLTnkv?=
 =?utf-8?B?Y1d6U2tkTDNGUHFLRGhLdGVxZ1dUdzVidi9VTjF4RkQxbFd0S3BYSnlQTWpV?=
 =?utf-8?B?WVFvTWorZS9wM2pUazhERFlLekhUaVhCbGZ0Rkh2QjRtc3RrdWJ1UDNvVEhK?=
 =?utf-8?B?ZmxrQWY0bDFoY3pJVFdKWVJuc2d3ZENvdHR3OW9QUU9vT2hHOFF3VzBlMTVS?=
 =?utf-8?B?VDVMRU5VOEx0Sm5JZW1IYkFrVVR3OFdOakNMb09XSlBKVWtncmtyaHhNVUNE?=
 =?utf-8?B?R0FsMDBIcVFUQzRDM0FPczEyUkcwV0dhZE0rWnFoYmZVMElGTHNMcTRGL1ZJ?=
 =?utf-8?B?RXRPZUZFbWhRblZsZ1FRN1NNUVJMZk9mdFY0RS92SkVHT2g3eUsvNFY4TkZo?=
 =?utf-8?B?M0pFWHRsZjg1K05IdS9ZNllhM1VCTC9hbGErVUxrWkRoOHZSZHRsMFd5cGFX?=
 =?utf-8?B?cHh2SVBkcGNLQ0drVkRURENrekc2L2RKalBCMTlzZ1YzRzEvSjd5RlQwV3M0?=
 =?utf-8?B?akIzUFRJUk5FSU9HZWE4VzVNeVVTcjZtZ3c4REtyWlAzQVphVlVQMDJZbVRL?=
 =?utf-8?B?QURFaDhSdnl3SVpVenJpOEx6WUtMRmlQUS9NUS9IbS9EZEZ4MThvUkRjanha?=
 =?utf-8?B?YW5XMjRVRXZXUzNaUUZ0b3Q2cjh2cCtkakFHQWhGYVdwLytqZFkvY1RXUlJo?=
 =?utf-8?B?bEowbDhsNE9nYW9KU0FRL2I0VXRhS1hVN2NDckRveEU4SEdQMmw5ZWpLNWx6?=
 =?utf-8?B?UWpsd0tLTUJ3Ni9GVy9yYlpUZzdGdXlBaWgyOXQ3dTd4MU05NXJ3ajZVR04z?=
 =?utf-8?B?RElubm5vNmw4dFFIMCtYYjE0ZmlMZDVKL0NPN2V2bWVBTVg3YkR2UmNSTTRP?=
 =?utf-8?B?aGdVNTJzOThnbzc0Vk5yNkhuQ25WallYNnRRNWw4ZWdHR21MY2RMTlgyMmRQ?=
 =?utf-8?B?akhtcW5HTXRmZHYzZVFlcGxXN1kxc2ZXYyt5Q0VicWhOeEVSaEdzQlRTWjBx?=
 =?utf-8?B?WE40dGxKVWF3aStNK3cxdVl2dWp1cVVzWHdEYnU3VzhLYjBtSFN4ckRuN2ps?=
 =?utf-8?B?dzJwN3NlMmtNZW9iQ0ZnUUJGeW94Ync0SWg3T0xIdnc0REFxZGxGVW11RnRH?=
 =?utf-8?B?VFZ1QUMwbERhUHdaQXFmVEQ5ZEpRTkJuOXM1V05QSlJWNXJaZG5RcHRtMkFa?=
 =?utf-8?B?eitYZVBEUjIxcFNiTHJGYW9kdEZudGJxSHo0OWNUOGRXVzI1ZVJlZHdqdFJ4?=
 =?utf-8?B?b1E5NTc2eHJIaDVmRllCdnVkZTVkUkhseTRhcWtMdThnMnUwNVRybG9jMlhN?=
 =?utf-8?B?eVg4QVFRejZsc084a3pNVHEvN1hyYTZud29yeFQxRk8za2ZuVm9xcm1mVkZ1?=
 =?utf-8?B?Q3FUcFhYNExvVGJmdFpLNnV6OS8wWm9KbjI3Q0poZVdpeGo3L2pvT3pYTnR4?=
 =?utf-8?B?aWxtZGhwbzBXaVppNlBpSW0wSU5tVEpZcjRIMi9vWXlFbytCTGlGNVZRVFlu?=
 =?utf-8?B?Y3NaUnZ5WlZtZGxLK2I0KzNlR0d5QzQzT1A4WjN3VXZwQ09ldjAvVkdvYUVN?=
 =?utf-8?B?L0dtL0hYWVZaTFpjS1ZrL3FrZFNNT0pGam9RWWtQZEtZNW5Ia0xKd1lDSDZB?=
 =?utf-8?B?NDkwL09SZnpmNW5EVlMrMmFlT1NUMndUWUFILzJBVytTd21mRFE4a1crVTJ2?=
 =?utf-8?B?ZE5McUhQUVV6dzNEQW9maTZZcTVxVi9zeWloYXQyYVlNWVpIZ3FwZmN5b2do?=
 =?utf-8?B?KzJjY25TWXpDSUZ0MjgrU3FqcW5xckZRbjkwOTJJczVEbFU3TGxOTy9mS1Vr?=
 =?utf-8?B?QUwzUjBSL2R0NktnblBOVUY3N0svOUovd2F6S1huZ1IzL2orcGE4YTBYQXBq?=
 =?utf-8?B?cGNkd0wySEsrdmdERm9NWVZjYTYrcGk5cDl1L3N1eEpQcGFaZUdqS0N0SytY?=
 =?utf-8?B?ZU5KeC9renhRV1pxWG0wblBCdEF3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18cc71e0-2378-4610-54ef-08db442340b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 17:50:40.5271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KL0R322aQ8FDw8zI5YS0oUo13wbYFssBSMp51uPXzEhfhrdHgwmASLX2Q3JZBzNH1NY+hlU68lvDOJ2o4UFuZmMua72ApW4RINf7OQtnlhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3698
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 01:30:25PM +0200, Toke Høiland-Jørgensen wrote:
> [You don't often get email from toke@toke.dk. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Peter Seiderer <ps.report@gmx.net> writes:
> 
> > Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
> > calculation (do not overflow the shift for the second register/queues
> > above five, use the register layout described in the comments above
> > ath9k_hw_verify_hang() instead).
> >
> > Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
> >
> > Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
> > Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-F0177FB722F4@seqtechllc.com/
> > Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> 
> Alright, better, thanks! Let's try this again:
> 
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>

Thanks, looks good to me too.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

