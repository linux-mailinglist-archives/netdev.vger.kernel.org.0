Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0936ACAD3
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCFRkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCFRkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:40:45 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20701.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::701])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C219C43461;
        Mon,  6 Mar 2023 09:40:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxwZtkBOOyvx2cBsLSpbYKKHkGJ7V+pnbFoQ9vhF1mePaHRkMymmyW902J1duQmSNQAUjpfjZVMTWrggSrhjVDK2KKc674n+U4tpk6HRh+T7MlyM+DeaBGl+TlFd2e/Q1wAe1d03u/UKhKwZoKZjapzH6Cv3UAYw8qGcIXx+D1bC4+sxgKJQt6ICwmV3LHI8lwCvKCxsAXD1pp76+6hcA6pabg0/AlUda97GJwvFEI3RAhhgq5uJr02pFIDniC09C3ANFfb/tk4gtQ1aYKX+EJnYbLFm/90XCGZE/tMxO7brrS09J5ZZ7HrH+CtsxVF4TN4FIAjO5aRTN69+RVU/mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9/lk82stSAiD42uyRf6mzdzsNSxmeA8ku5yPRIZdgE=;
 b=YUkp54UZot3SiEmXSg5CE5veDCx4nouGfgnWCsfIwWXMVGWywXOkQ9ZkQRv1KB+41k0afRkd5Kn9dWiMFrYbDMPrJ/UvPWXYMYhhf4EuW9VTnOw3830Ph2xcdRDREwkuAHPb3SqhNFYmrDBjWqppcdpG6TFGTFbexLZqxP09LI6nUV0DOQDUBhXzfCMdIV35rXKNEH/zTVzC8btvFw6vHE9/gPQMrm7oMczeHL6a4Rt0N+hYsOWtlkl62OJR5sn78LgfHoyUOxFCX6JuPG5k6uyHIoVxMzbD48Z5enT+F1vLb/0sZQGBT8rLHqognUrXaR13ocF43bwMDfhXLLqykg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9/lk82stSAiD42uyRf6mzdzsNSxmeA8ku5yPRIZdgE=;
 b=dg7I1x/5NzSenWFeqJmP+165pGbqBYqr1mAw3nNFNWZSS+f7vCciyG+KIPS2mkBF754fA+n+EXwc+SyvN33ki84uhel/71TOm4W79T/HgaR5Lb48UBb6y7UmXuqChZgsmDdsIIXamrYOla5yHZH6odYJ1M081U3fZjvmjYDljeg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3699.namprd13.prod.outlook.com (2603:10b6:a03:219::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:38:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:38:14 +0000
Date:   Mon, 6 Mar 2023 18:38:07 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jaewan Kim <jaewan@google.com>, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 1/5] mac80211_hwsim: add PMSR capability support
Message-ID: <ZAYk/1g3Hz/UX7Ir@corigine.com>
References: <20230302160310.923349-1-jaewan@google.com>
 <20230302160310.923349-2-jaewan@google.com>
 <ZAYa4oteaDVPGOLp@corigine.com>
 <addaa95e4c2e840ac041efcedc99a235af90c6c1.camel@sipsolutions.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <addaa95e4c2e840ac041efcedc99a235af90c6c1.camel@sipsolutions.net>
X-ClientProxiedBy: AM9P192CA0017.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3699:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d7557e9-29df-4b28-9150-08db1e69902f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lVuXU6JoPtmOqV0evRdyYvmgLzyXLWxU+OQHrBRpmpfK/8b31MYawybSlVKSrjpc2tGFTgGkYfSv/jNf00n6Z2YBItYg9BlvmulR9Sjx4YbO27ZKdBlWu/TdCIBC2oqPC69vpODGIf4XnxkSMU4NcjGjeambWQYHhkJz/wWdjIqFInqtiESJjboJigC9Ffh2fabITYIdFK2+l0WaIzShiWCEMng2RTLAwW+s4l1OrdOqt4ZR/kJFOj4qLy2YpfUeB0qT4MVq3POzQuG1oJVDyhrDImwtBCrs3u7NaJRnNomZgAUOshGEygjJxrQHh9rMfx0+loT2zXZJwk2aftXgoyclStiPaBn1RjGF0AIFxU9crkcetaF5M1yHbWXtzt9Bru+RpTJHWe2z1qzc50bbQ0GjSppQjZXHOaxX4vWAeT8lk0aP786ZUC033y1l6FuxGP3hKtiPROo+QPiLY6oWwFyb7mPPoGjoLDyzFKcv3HbLYgJQGWuvg61ct1uM/6ZGm75e5V2+hfZ7fxUllPbXexbuKLx1A8gl2u9DsjGDYLRHGIuHvoQachlkKAkBi4UK+ZPul5BlWqmrYA6xA7DaaWVqYA5RICxxpyCE/MlciihPgvQwOMmaoItn1yv0UuvAYCaIJxiGIH3irGJ61fNi4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(346002)(39830400003)(396003)(451199018)(186003)(38100700002)(8936002)(66556008)(6916009)(66476007)(4326008)(8676002)(41300700001)(66946007)(44832011)(4744005)(5660300002)(2906002)(478600001)(2616005)(6512007)(6506007)(6666004)(6486002)(316002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0KaAUcua5vcI1VJ2B9EIi9rxGYDyBvJAq7e2lLys3eQdeirYW4WimKGAlXwU?=
 =?us-ascii?Q?6HeO5i4jWnbDTr6PYBa/KGjET8ioBIElKJ5CdP42aD0YLTpT4sauwvY5mhvC?=
 =?us-ascii?Q?wH0Bb9aF9RcXC631SiYBlxFupjAZ09LZXeHf3fiomE2236zI7KWxA42lUgoT?=
 =?us-ascii?Q?RVUqh7MzNjl3m/ooRwmYwgBJOly8ehx8hLK04MtlmFJFUDO0VLXoQXfoWPG8?=
 =?us-ascii?Q?Xv0qt95caLHQfYTsdNewpu6+AyVtCbq5m0nrEfQ0crBuLFYfvQDtIIKiyl2e?=
 =?us-ascii?Q?ZRYlHb9E426OgyX2x4q9jsRycL182sJpLH8iO6kmK95zcoiDYwDt9kGp0R5t?=
 =?us-ascii?Q?XjP08MuBI3satFpT0P+EB2ceKReVsLmb3TY5ZVuVLpJha7vXJpYeY1Pd35TO?=
 =?us-ascii?Q?hIE/cuA8nGBjurjyfa2jDcWChEWQM3bsq4jYlCAvnx9CwCA0GwXKLDUxMgR6?=
 =?us-ascii?Q?MV8oqk9mogC2Rj3tfvHkH13O/PPFiYSRdNTHc7yIR3vd3juJXXqudinnwLVP?=
 =?us-ascii?Q?LV+dn1QIkV53eGpQJ2D6bdFU8T1AVJsRvhVY+fGmmC8DbQ5bqWmVHKZdSp5j?=
 =?us-ascii?Q?RDXjqTAa2nK13sDoAkQBWA0W0wS3Fvyy/M/cq9yL+uNcZyLAPLeP7k2g0V8w?=
 =?us-ascii?Q?pcVkNJeUY0gT+SgU7BBsdFb6jAd5W490yLgkyhs/0SeJytWD7hGpYpP5ejFx?=
 =?us-ascii?Q?VRQf/AiUW6YlkKZDB6+joehNdR18ICYM2MPa1Wkj/s+Knw0GMaNUkofcELWC?=
 =?us-ascii?Q?ToYeJft8FoKijBwJfH7s6Dii5/by5wTWXeCU8ov53tDXlq6ejEyLsTW89PsS?=
 =?us-ascii?Q?6TOzlwyDIQTEZid5+Xyq9FK3Caejf+JdWiiDWIrabNcgNfGSnFj0dZtFlbwJ?=
 =?us-ascii?Q?Zd1gT1uo5q6P3pUSbCWjO4LUHy3mJ1fxTtHeEBXNn8fWpaj+/LyZHFeSAYkO?=
 =?us-ascii?Q?TfszwNWPPkc9tJ36xlGYBsgOhQC7MPEDJwcJGgcugjw5C6TkscBQdaRXQ32p?=
 =?us-ascii?Q?l/Pfka8L3ygCODT5Zk3trgA4moauQLyGTmB+de0owc0hQSpy7SmvQ0KFrNDj?=
 =?us-ascii?Q?eETQaKVbLxDM5If+++fSFmi+R+84nloCmRWZoZml1B86JNrvmNX4K2uC2tk5?=
 =?us-ascii?Q?UWAyUHUFvom31jOEbV+LQsNwqtUdqwNE6ydthRcOlOOVHOHRadZOSge/fSrV?=
 =?us-ascii?Q?J2kB0xbAt8T7i0XEQTsJp0qzbS15Hf/RA8WIDv/NVk0G9EwfE7OfvQ61bS03?=
 =?us-ascii?Q?1WtUbolU9u2Uu3r78bW59ps6KJAZicJxinC/L0JHm8Tc2tP4bximXZb0OuFX?=
 =?us-ascii?Q?vCu1emMDuT9ksXbBOnp4KswM9mekOWXL5GVyVdwCfE+CDf0WCHgHGeDGfZSH?=
 =?us-ascii?Q?s7TVnp2tXjs2fYP0ealM8PGN38SiAJ4DstHy41H5d3N+LArCLdxNkIk/DROE?=
 =?us-ascii?Q?kTEO3/WgNPDaExvj6rgfv46SVcN2u26t9Ep0mKfVTRpiuriHAztplrqCSOwU?=
 =?us-ascii?Q?9A5TfVVB864q+iCC2kFFrGwUtEUf3WZaKR1LNrml3EyX8JCXOkOdIhiXBMyL?=
 =?us-ascii?Q?sASeuyJnwIk5AwnEbdFQlW68Hy2zM4STEk0qsSlJ+G4L4OsANxZsvV64Vedi?=
 =?us-ascii?Q?QivKctnlHfBnnuMn+z54OyJh2EX8+J1qwxS0DYYEWkcq3mD8x47UU9z0K1ov?=
 =?us-ascii?Q?xD3IiA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d7557e9-29df-4b28-9150-08db1e69902f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:38:14.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B35EFPici1t4jeKKNBT4kdatjvxa42Cey6g5l29Py3H6R/IFhhE7vLS53rLJvhhyn+YyvzLxCDs7mcq6T8pbYuuAAfpNsEyv2V8zidxHYeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3699
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 05:58:37PM +0100, Johannes Berg wrote:
> > 
> > > @@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
> > >  	u32 *ciphers;
> > >  	u8 n_ciphers;
> > >  	bool mlo;
> > > +	const struct cfg80211_pmsr_capabilities *pmsr_capa;
> > 
> > nit: not related to this patch,
> >      but there are lots of holes in hwsim_new_radio_params.
> >      And, I think that all fields, other than the new pmsr_capa field,
> >      could fit into one cacheline on x86_64.
> > 
> >      I'm unsure if it is worth cleaning up or not.
> > 
> 
> Probably not. It's just a temporary thing there, I don't think we even
> have it for longer than temporarily on the stack.

Thanks, got it.
