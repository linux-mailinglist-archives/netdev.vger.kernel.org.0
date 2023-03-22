Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2184B6C491F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjCVL0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCVL0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:26:16 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2112.outbound.protection.outlook.com [40.107.101.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B9C6150C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:26:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpxtbmTydjVgg8KgLzLkmcbfJQrAWwOtGtQKQmvFnxQd25MCbtPbSg//2Yx2BC8uM/9ztq1KSX24xucMR/WWaJOajyKZzCaX4aVt6rm90mcHnwrq+3qekdV7Gf9hFvsKKgQwzRTDZzizDGhX4FxEghvLOzddeOqi8cnytOOqoGD4Br3RhvpDJnO5yK+Fl3XabjMyr+qptjjWYR9b42CWMUNBgjM1lBqAT9Ypx5I+147nOaELSgAk0pBEThalm2sp8qmvhf1sjSZjIV1pd5ylESWqc3F+EIWnsMb6kQhZ6LdQ10eCsiWLiadsu2aAC1eiW7mbtlqg6YuMuPvnQMp2AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1217+1M1YpKLNzdHAeMS7MWS/VFxTpFceK/ixheEp3I=;
 b=Nn3uuCvFrO1nHilXAG49/rclmzt+ecXMKrWnd1ImrW46lRaz/FexSR5t9JzoST8HjLgpLrclDs64lENXVnjFMnV2FKhblM0tKUcQsBm2fanHD2qZ3lgSBoHyAXC6W65kjTps7E7VPu+adYZlMEaIoez8SY+rl1wUwo8fadtgc7+J+//4e6q7wbMIJMuvUtJ5zkIhAvnlf86WyOkmjw6bRxMk60/ZP9rUGyurlwVU3yEU8NbFRI01aUJD64IKOnPSS3ag9gik9Pd6wkXXTF+mCj+a2P3vjYWEBdO7H+d6VFbfVxRo+3O1ZS+191+UmDU63Jn41qntZceKqbATGzUPew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1217+1M1YpKLNzdHAeMS7MWS/VFxTpFceK/ixheEp3I=;
 b=c3kzjkRetFxcUmgnGqQHVfCwAirs+SRsxqzZ4jCRErWWnSMMMiw3RRCkfUHR0TND4aO8+6eSrRoteGdD37OIP5KR+RGfxyzZOv2PtrCB1zIDJeafZircY5mIUROIXVJEOMIFUqBLXTxRkqz3o+FPw8+drla/dHDBLUD19RPu7tY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3948.namprd13.prod.outlook.com (2603:10b6:303:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 11:26:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 11:26:14 +0000
Date:   Wed, 22 Mar 2023 12:26:08 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 2/3] sch_cake: do not use skb_mac_header() in
 cake_overhead()
Message-ID: <ZBrl0FQHaHE6xTVP@corigine.com>
References: <20230321164519.1286357-1-edumazet@google.com>
 <20230321164519.1286357-3-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321164519.1286357-3-edumazet@google.com>
X-ClientProxiedBy: AS4P190CA0021.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3948:EE_
X-MS-Office365-Filtering-Correlation-Id: e2859ac7-f3ac-4a0f-9913-08db2ac83ed0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OthpYO6G0OAVwIf4ItPQ1PQy8uvD855esDhrCuKEgqG0pxYGOQEewDx47L7mt5wZOwtS2tak+QBngOdr+fCmHfQbeolhJZM6hwGF3ba64VW4j88p6RWm4qi9V7Fy2c11Z42BIiVpmKDw11OMjZe72AlnOxIy89Mwje+Ut2TyF48PxfGnrtxLupWmRozEHIo3RcdABB1fHVlYNhDkZimQkvppnjcf2hDmKwAwyenmxUAsPx889C5nM/Oy8ZUzn1ZrsXyyWhHHZJ5HJ8gg1Jg9XjtI2g05/sGk0IOcZ8vtJs1/k8pm+6YA/F/CG1Rck2rnADQKeEGrLOGm1pboyU5u7cKfkgzG4Lt3bOk+kgyYtl9vnUn1E6oEux3rxbjU+3nAtPsh1fxxJln8lmr+U8zEees6qex/jvVji4gFPiG9/bw6DIKTKAO2fjLAXyNqwtLU2of6YdyIXdgWVst11zb/55qDnZOZ8YEf+l/0r20N33WBFGUwKGfGdsEPbc15vVfdf5mgswfV6twgFXb4qdphXa3UBbAeOqLBOYTe+lfBofEBBYOHO3jDPoxngMpJ/ZAAcJTD9+J17G67fluNCMt8oemEa6yPtZIxaLcJoA3AHZ1rVIrq/sBxfJHCng82x8UE8b336dCuHUnI1VGegh4W3deKuPT4unrsg5Or56qxLwtMXjBOu/km9tpL9fKSggR8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39840400004)(136003)(346002)(396003)(451199018)(478600001)(186003)(86362001)(5660300002)(6666004)(6512007)(6506007)(2906002)(66946007)(66476007)(6916009)(66556008)(54906003)(4326008)(41300700001)(316002)(8676002)(6486002)(36756003)(2616005)(4744005)(38100700002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gi7ZCWPUZ4MxTTP+qj3c+R/ICP0h7OwQPV9HSWBwcflLjsADQk9fGs4zf/Ci?=
 =?us-ascii?Q?M9pSj22JgDXmBzXPLMu55jWZ75XvR8ihmZFlQwia3+Y3wcNmln4HyFpl1M08?=
 =?us-ascii?Q?sSkkYlnk5FlpA1C8xBFAIyaDWcbLdoqJxvQE2TSJVCzGkdCbOVBF39PFAcTT?=
 =?us-ascii?Q?ZbIHXlxUrf8AVP2xX/HC4o1SvmcvOGk9V2RZNv1FTE6v5hM463W+D8Gv4vL8?=
 =?us-ascii?Q?V8JiWLmDF1tMEVFZcg9S0AhdXBtk36+AwbP3xrPOJ4fG09moQi3I+gC1HpzE?=
 =?us-ascii?Q?LnkpU3apnh0vwm2JuyyiFfljGJfpPdTGJOA3Pma8T0k6Z8KBmbLcrDxsUhWa?=
 =?us-ascii?Q?Z10DyP4Q2LGuu7/jGZOzV8A+xkfHT6AP4703lz3SESA8VkL8ipwy/OFulZja?=
 =?us-ascii?Q?hCE5MwtGlc0PGj/+3U9dXA1TlQJe1fdknVuCwQtCZxRhVbB+ptzOa3uLu8OH?=
 =?us-ascii?Q?YmJN2CIn+l5xCqceeS6fVZN+zy6hoDCFcO3JhFOsxzUertQpgLvghE+RJnSV?=
 =?us-ascii?Q?IMdk9/s2+i2Yl+B/ZXyapNoeHkUcjishHugLpExR/A8cqYldJZfqQSsUYZdE?=
 =?us-ascii?Q?BEFFMi0nVW5yUa6/HhgS5Xjp2vZOyd8hvNjnkEnSd41pYXgguqPguUY82fbv?=
 =?us-ascii?Q?HP+eLNnqU6o7xgKh5PalE2mG8CRUInSMxI/3LeHC+SXl/L9FxaSrD8xwG3+7?=
 =?us-ascii?Q?9huO88hf+gNRIeanD/rriEq+rbj7vVf5Z6ezpMvowvHLe78LWZFHemZ0skbm?=
 =?us-ascii?Q?PJHApGOAwrC3BLH4HmMXe4QcttOIcb6h6zSCcF2YtDzmai77CLfO3CEnm8qg?=
 =?us-ascii?Q?8EyzeAyF+wivEfd/najlM0Cbsq4bbPl1G5OIi3AKTIebSBazat/HXxgq6OVg?=
 =?us-ascii?Q?hM7cVFI/2PO7Rud8jwCd/R6aoBJOXYVu3FIRqL78GxoIzmnXweP/ZaC1LLr0?=
 =?us-ascii?Q?00trU2RbM5OIQUEVObDQxGr4vTIbKyL0nznFyylxr3mddJOtCpfMHjV3JFd3?=
 =?us-ascii?Q?Yqw3uOu3FuIX4QJf6FUh4300lxh1vz5N41zCFnC/jsGFH/ZKGjNw7zEVzKKB?=
 =?us-ascii?Q?MEQO4dGtd7O3FL3+ow1xUXpY7+ndbKUG0DqJNkCFLP5Zu+JH3YdSgjE6obDl?=
 =?us-ascii?Q?wImZJ0QUkUnfaesg/PzV9gOgFa5Pe8peFCad+/U6EezYWcj52nvKVF1h4Fxd?=
 =?us-ascii?Q?oBPQIKOlOTaPCcHl3qg9gHz8s6ewvtrzRoI/QWtlt+3niXcDm5Kd/0KpaMAZ?=
 =?us-ascii?Q?X10KZetFqpbr4nP1ieiZoC9njWlINDJOT0DaxZbw3rG0Y40ILICzT5di4DL4?=
 =?us-ascii?Q?HU3+ziRM4uhe/Ut4MstkX+XLO2xbUhdOL2GeNWmDhYlYlDDTHWiOg57DXw3K?=
 =?us-ascii?Q?0xnaFO4kLtrdByidWyVQJh4IT0J/eoVTKP9d/HRSoNba43qJEK8/5SqTfZHt?=
 =?us-ascii?Q?jhybWGjzu30K3MgDUBNgBw1uwOcVZEOIK1k0ORQ9OkflNqT8IrHQq0DVZdwz?=
 =?us-ascii?Q?u0vwfZplzn0M4A7vVi8bL+SWI+6qq7Pz2IMT6JR26b/prHoW4Wo78vIURPAL?=
 =?us-ascii?Q?vI5OYrBZk1lxlE9il7hBmI3czjOSw2uS1k9AT1nWT5ZGFSmMdbWI57hMAhSK?=
 =?us-ascii?Q?iOgzLqDiZq/K+WvavkxIb3OJfT8GGzW/A0XVakHtMWXXqlacbOg9ybgzdDNr?=
 =?us-ascii?Q?WFwF9w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2859ac7-f3ac-4a0f-9913-08db2ac83ed0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 11:26:13.9990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0GKl0l+GuW2ZpjwePU+XsqU+QowLIFy0LKMums+zFtFHflVdXLuV/uhMeSIp0sBHbyWD5TysTsynsZpFzZZkPQ4ds1FmOoivDb2FldDPAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3948
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:45:18PM +0000, Eric Dumazet wrote:
> We want to remove our use of skb_mac_header() in tx paths,
> eg remove skb_reset_mac_header() from __dev_queue_xmit().
> 
> Idea is that ndo_start_xmit() can get the mac header
> simply looking at skb->data.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

