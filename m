Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA70682CB7
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjAaMhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjAaMhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:37:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C744DCFD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:37:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UonAuTlVoRT1WgPmqI5XZHyGsHP4mUYuxpPawbPZtqmyrzURf9/kqSsyGxLTd5Otl6eZ21vSD1p4YcwOsfOxy/i5SzIYqKGsIbk6JigdCfSav77ULbCEA0V2PLac46kTDoJQveY7n0wxCzY9yEAkSuDDVNLC+aaoVOCQ5B8SulmP5shlk+czP9yUdIG5Xv3pUR+a+bNU+MQFxoPHaquIOBO2H5ZZMAfbWlvbrN6h/MrD8lwBt5/DkaQTfEeo3hJX/glGykT9qJu34F3V0ujt9BWEhmSb1vb+VfYVBTVNYSO2k/auF3qlXw+3yRZSm7bVZuzrap/WY8J2uNrwt8R9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2FQPOvZeoDNw0eslVthLRf8R/TTDdgN4GOmlBBSZx4=;
 b=mWRt8BoILhLMKmmp/Wnzi9J8pyYF4FpZXe7ukYX/5FMHmTqul3gIjRRkvX9YIvfoEbCnrbj1UXQjwsJOJb6LBgO7y4iMp0+X6M+nW/lHEgr2VPmvCgDWgJmv3fJGvJ0aFIejrVAatPhl/n5cBQwRE79lWoHERyVeirnMyco2Ecx/GHDIBiGhMcZrJwZwFtKZnB2MwWKlcTGkFSI3Dju86FtAuBNcWnV+xj7a4oQCUUL9rqjyut5kQEU6naOB5436pfpBG04ihttbcjF+qBXUNW5Qx57gXn1s4K06iwNtlZkNai1NGue07qZgVBtTsrych+UUybSe8E6yxDrVIgMWqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2FQPOvZeoDNw0eslVthLRf8R/TTDdgN4GOmlBBSZx4=;
 b=TcaN3cwcapDfg8E9oUCi/6CRkYKGkPxVGtGHlUWKU/sPxxTKHb2NlCZaqhfmHisrkDYot1OCAAehoUphIV3u0Wh2s4oSIDZtUi6Wf7C0w96qZ3SGWx0yxYG8KPGSZY7pKZ+iXGeoJ86PsRC44eZTzn7Cz0bK6P5cdF+hflc8wHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5608.namprd13.prod.outlook.com (2603:10b6:303:191::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Tue, 31 Jan
 2023 12:37:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 12:37:29 +0000
Date:   Tue, 31 Jan 2023 13:37:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v4 2/2] net/sched: simplify tcf_pedit_act
Message-ID: <Y9kLg7gsb+4DfSsb@corigine.com>
References: <20230130160233.3702650-1-pctammela@mojatatu.com>
 <20230130160233.3702650-3-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130160233.3702650-3-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR07CA0008.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5608:EE_
X-MS-Office365-Filtering-Correlation-Id: 525719d2-8229-47d0-637e-08db0387eab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4EkfsCnmWS4QhnvWyNH0TjgyEFRMyAWAsXRTpRlf+zno5qKX5hnOH35x8rvuQRZVIkPvW6cpj8J0xXL6m6iGANzyObE1oDIYZrNK0s8NAc3G7lYzWqfBJ2/J80u0GusVa+kyfgnkFJQlH7ROsaxlsRh9kAHexYapvBa/vQs4TECL1y3Vvn+ApAFCd06PKyzzv/AejrCVf05XkqikT54zzn9EzpE/wk5XC68caVPRPA+TmelWawNWM3nJlWGABSvEFrgo2gRm+uL49DOC/0TVsFPmcpqsuonFdye+Du5KYY59jZepYsaRCWAVow12DOAfG3RQkudmqXIEv+5oCWFGHLgD9GNv0Zq/jbs1lSbKxG/MEZLMgnItEbGRLWhCqCbvvC/OlokgHYzHc3yhEIErG0SHVwJMS4ggm7oJzPeP0SmLoEdMcApg7FXKmeXZow4HN2WegsFrjHbrlZOiPo1VN/RyWy0Ew293y/ZF5kj9jEI20CqySYl4m4VTw6dsLbithlCPjl2MzlzUsWO5w/j2W0uEwfacFV9iUoA1gNB6L8yKK895gGHTqDHVt4RiTM86kJbOO4muFZDAoJ1q0un1/4YlWDnIDe1zM/ktsQWLK+Sl2ZwucO7ItqrDpJh7m94/R/8HAfN1izNazalUYHWlQCtxSgLnYSwHnLvcPEnHJADNGEr43UI64wmDWzqwn3VsLspzDXQ8zlTCx1gfFiwACgnDLkEOnNpptgTqZY8b+fmGTvoRacDc514Z4ncHlTE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39840400004)(396003)(376002)(366004)(451199018)(38100700002)(6486002)(478600001)(41300700001)(2906002)(36756003)(6666004)(86362001)(44832011)(5660300002)(316002)(8936002)(66946007)(8676002)(66476007)(4326008)(66556008)(186003)(4744005)(6916009)(6512007)(6506007)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LY4wMlmwj7pVHoUu4h0jf2pBCmSzcqb8e/aNtVxe57RVUWmbkE4XgksPmFSc?=
 =?us-ascii?Q?iFWuji5Ms7a3I/6WVh4zL+Ryy77yJMksG1TjspxL1UkuoO40mfs57j1lrj3I?=
 =?us-ascii?Q?4wwkVLUwSAzIwEXWPSyakXJWRXGTmvYk9Aq8ODwRz49vJk9tqgAo5m4RY10K?=
 =?us-ascii?Q?BWppE45tJOEHTrzR4owSwNMS4K3BoujLIDF85V3O6KLGgBiZMivwj7k8aNf6?=
 =?us-ascii?Q?oVMA7NnF6wyJpfM1NmTuKgpP78OHTb8LpqGN+HpwkRZVCUQ+fooL3EteTr1Q?=
 =?us-ascii?Q?FtNrb2WWR5AKMNpvv4VvVVPPpZCpf+GqxyoNI4D1j83zCin0rmMIxyKUD8K5?=
 =?us-ascii?Q?ax2mScldh525aLmWt2HBytc3+2I+32XJ/TB52Di08kp8meTULTi5EO02I5HT?=
 =?us-ascii?Q?MkSXcWOQ2l24UfhX/zLXuEg97m+7Lae0kdpSAQEWBL6FnRZqJvTrp3wyPe05?=
 =?us-ascii?Q?xaX3cHr4LmxvNexOXU1Ss9Yd9YhOfW9/pkBQWqquQYoUGq8JVxr6C8hhHecu?=
 =?us-ascii?Q?nPXck3035ku5vIfaZITQ9OZ7GvJl3qbcEVQwTyrnvVzTNUlY86Lei3up+PLk?=
 =?us-ascii?Q?jGHdl5AW/txPl9FwwmzIIX9qS8q5aZM3S4BrS53p8QaNczAv0D019k8lUmOc?=
 =?us-ascii?Q?N4v4HdjPXboSPoSSCcMaAf4DHjVynsbCtF9EAHWZurpXxLDOBUXmVPiRgYPw?=
 =?us-ascii?Q?4RxgHn9fM5KOzyZbJsD+hF81sOSix9nufN0zU/uuBJy+Fu+Dx2R15UpqoDXl?=
 =?us-ascii?Q?8B6NAMDtnJR9/Ss+IEiExzHjDgo/w+DjRden7Emog//Yn+MHEsGlpMx8YjMM?=
 =?us-ascii?Q?stJahrauFlUNc+Ibt/Y7ONze05mBwqBX1Y3whQCzrSApDW9f0VgmUUGh4YDb?=
 =?us-ascii?Q?W55vfYqbN11lfaeEysZI/Etu+VP4VigI7ikx7N0y3LUAowJiyneq5y/5rbug?=
 =?us-ascii?Q?Ckh9/dlVxtyitjCsw6RQyfPxHdpYZgZZVaJCvZV6y6OmpPQlECxs/z4qljgm?=
 =?us-ascii?Q?WTOSmxCgzt/47cUnix1GGnahvBUc8ZcMDDgjt17Se989aU8/AoxWulzEIdvZ?=
 =?us-ascii?Q?JzEy3pehDR6+aK8DxGJRgcgZOha9xgQWuOUDMJTXq1vJT51asKUJQ5a+3w1X?=
 =?us-ascii?Q?ryUL4f/ZqceykLuZ5oZU5QA2AN+PFBH6nmZpNWiJeAToZFZ1WUdT64QLGlrj?=
 =?us-ascii?Q?Vz6Iylle2/uQfJi5HBFa2a1D/TZkuJYYvW9tNi+I3bajwX4Vva+MRl0OGn7C?=
 =?us-ascii?Q?5A6CWacK5PJk+6VjO6N7lfyTW38IrTo6FoJtm6L5pyaqKPOQtO/PxQJqYx6z?=
 =?us-ascii?Q?JpRNIw8dDXVBSoAa9K/lJc8DM7rhDjMGva9bHDJougW/OkMVWx0E/ySrOZZU?=
 =?us-ascii?Q?qodj9eMOtBiY8PlZw79kXnjnuVaCxInuD7rYPHsxWeefqRECxMjpGWD/Uiwj?=
 =?us-ascii?Q?rcqwvj9CQo9ZXYNsAQulMBsj1mur03azbOJmj8/Jicwh0wmBw35Ivhlj4axS?=
 =?us-ascii?Q?wbNrLJIY+59FIgaVz0eFz8NPFIKW9SmCU20646YqzzwarNUOjzTxfAqgxxrL?=
 =?us-ascii?Q?s/dvi/8ySChrWcyXUKCZp50H0CeMV63dNMAiIx9mTjgm0uY0J/jCdDqhf5gx?=
 =?us-ascii?Q?HFVejjGRn+XXDlNx09f2Inq01nZCt7eFDpuoftotRKBZNiybedDG0ugaPy3a?=
 =?us-ascii?Q?s2BnqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525719d2-8229-47d0-637e-08db0387eab1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 12:37:29.7437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSdudz9Aw0h4zNhNBPLTvHcRsCF/Kr2JKqrmB/xx5oN50fKjSwF6lziPM7HsFdlEa0N5vt7TD5N/hLC2hry1Fvh/vfkeFagYbi5ZGaI6zvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5608
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 01:02:33PM -0300, Pedro Tammela wrote:
> Remove the check for a negative number of keys as
> this cannot ever happen
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
