Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE69661FAF
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjAIIIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbjAIIIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:08:09 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2092.outbound.protection.outlook.com [40.107.94.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966A06352
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:08:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZcs9LlNPyXc5hFsnGeOWnm3e88gm4SWQOCULMhNLFFZZPhjFRVuOrVYpnt9XdGauolOa7Nf6BRDVJDVMGG/eaxSmAuQMLm5tfcJomSMkO9kt7f7wHpJfeCL39vQ53WECC2LWwqQdcsojKtVkmm6Ym+QIagfkMMdD7yreQQZK6i1QJoYcUOXHT3nYBKhEqIGgLx56+o+cF6hvgGoyWQdoGl4xZBL8v6g3VY3OUcyeEzV37jrBVdXseqO8KwKGseGaC+5QF9/2cfaZjxsyQC1ojhRniV7lX8abKIfBkpsZONRc+XmVSx8yHxrMUZTmblK8NADnBu415zo5I0Od/EKWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rURDRV+Wtk3vMttkWXrKDQi3A5jy9v+DnIXiGkh7p8c=;
 b=hZx5n4ayPuq4JF0QCzgppCCrBr1T/VyArKu3jE3atKaPYISUFxcvglm7Bl7r2JUI/jmtWbGP9fpZWK8j5Ur32uRw5In72rgDQZsSjaDJW/ildb2EGrrA+GpYxdGUzlfw29FQOolAv1vKthExDZCSPUnoVrGXY4u5tTCc1yRwhVPZk6Qxw4DFLfujSA+81ZM9CS4KTqT6vHL10rJAkMwpxaALmPDnaN1jdt3uZUmzmg3ImTyBuaR7xe5AeTjCP62kltGm+HJo2m/KgGYTQinsvzNZiN7nETGm24GaoeWy19ixLtMq/7b5ob0Nlc7a8VCpfJFJDbl3T+zAoPieMAvxsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rURDRV+Wtk3vMttkWXrKDQi3A5jy9v+DnIXiGkh7p8c=;
 b=n9f8NOhU+ClvkvcUtTY3FYJCZ8fvdNyc6iqDNv/uuJdqh1W6h8theFULVgATZBJIs8ovWUi5Go3kS00/QsocMRz83CaoKYC7UizZD5GEvYpq4qDred1iMwhHU4aQwgbIEJxtmyfqD44JSJ/JO14VkMviQfn7SmzvIV1kvivz15A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4942.namprd13.prod.outlook.com (2603:10b6:806:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 08:08:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 08:08:06 +0000
Date:   Mon, 9 Jan 2023 09:08:00 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH ethtool-next] Fixing boolean value output for Netlink
 reported values in JSON format
Message-ID: <Y7vLYMhQKtdL7rSH@corigine.com>
References: <20221227173620.6577-1-glipus@gmail.com>
 <Y7a+dS2Ga5fdPJ1Y@corigine.com>
 <CAP5jrPGXVKsSNm=9M-7du4zB0errcmR9qHuu_GO=bvTZtccaRA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP5jrPGXVKsSNm=9M-7du4zB0errcmR9qHuu_GO=bvTZtccaRA@mail.gmail.com>
X-ClientProxiedBy: AM0PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4942:EE_
X-MS-Office365-Filtering-Correlation-Id: e358a973-1d70-4dfa-f3f3-08daf218a3a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CuOYQbmJrYOM+8PxAULaSdEHIJSMw/k132ZKdEct17Kpizj94gsSoeZ89kpTDEC3wEN92C+xhE1os5DsiJ99ThwMeEpEbB/9/Ll7V0X/NSj8eLnj5jHCDfYikJspBwQRhFCWPq8qBjDUBTT2wLxUtGSrZpU4ZT7MCSRaaYZM7Zsnemp2abnhjAT8f9zUJ/onAHXRCmgNMJnFPs8qDGNltXKz/uEC9Cmv0jdiBzzCPEf1QaUCiEKCDCLGPTYxU9nNJyO1iCruiCP3FtPbTji9zSlWuLz2hRg4crD3+HYFTVcM8k9QdDi4o/01fKQ1fVqsUgMrjVsC0PAswg8uOoD+TRBH3GLBXuAHaAUvGuj/TeMcN005zJ7HVJVB/DlP4/q/axBF32ZIq6Zj4DAiXo35vdeH1VCtTwOMTJPt+j5nGb0l/DybSlsEORC5C3HGcWBTs/d+EE8wPKTM6jgVSr23zFXvGNUgj4nRyu8jCplCSMkGHM9hJrfaEmwY0iNiCwLThWtfXq+1pH3k1Z4CDldrC1BbuEIcbQtpRjiQlgY2udRq3BO3rPyDf/3J0/ifPMUWyeMkzlByCG6bG6CbOFpIXzaDT/a5a/0oK64jtlzQyu0kbb+Borpl5c1J5+rDRfZBV971JV13aFXsFGuILV0y6FKC7CNWdFlYwfgcXIW9TnF+AyJlyD72AoGpnkjxDSYHgIHHbmuVlFyE863DIQ2jyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(39830400003)(346002)(451199015)(2906002)(8936002)(44832011)(5660300002)(36756003)(41300700001)(6666004)(8676002)(66946007)(66476007)(66556008)(316002)(4326008)(6486002)(966005)(478600001)(53546011)(6506007)(186003)(6512007)(6916009)(2616005)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ejL8L7VjxLYXYXuuXnPpeL7zYrcVlWLBlNTEmtloXc4A5g48436yPe2RdO0V?=
 =?us-ascii?Q?h8nFOAGerwB/OUWHPxurjz4Sxaxi/NYeYRtp48qCWFtXPIwbTB+XAcJFPP4b?=
 =?us-ascii?Q?kyFaFTNYuySR9QOge7iQt6zVM2KUpMmIksAFR0pvjVyiUwNV3xL3PEnN1xHt?=
 =?us-ascii?Q?SxzNZGOhUM94nCrH2KcB1jYdwgdm7oDEZAWO4YBAt38rCMwdGOF/yxrkrglZ?=
 =?us-ascii?Q?ynMqSQfs32SNkd3UPwHulk06PjFRqm+H9VJm6xe0K+9EsRU4bKubQ/vdRy36?=
 =?us-ascii?Q?b7CUkPOW6DZpulDmKqqHRh5v7Ukn3ZKEbJB4DFf9zSTJ13boDsLW8LvFdzfV?=
 =?us-ascii?Q?vA+DON0WdcCqQN4ngkrXEGSOskH0UkBscv5YFEI4SN2QiXZysgkxAlmPBmz0?=
 =?us-ascii?Q?RvgGNY95o+mOQJpB7h7CGaRJsKq7inGXVbnRK8sdZaKIggPHwcvecPc/IsHI?=
 =?us-ascii?Q?zmv46tn8Ra8MCqSr46t9IuSdVZabMlWp9gIxs4CFWdLdTIm1//UFpxn7Q2HN?=
 =?us-ascii?Q?/nETjhhMVQtv/21ON+23hSpU94bXHiyViq0a/dzmqwqxm6oVXHNc2MOA3+7r?=
 =?us-ascii?Q?OtUJqcvAvpMWeuEFPQFK1BjLS2AQb8v3Io+psEUJxOXtut4ipy7SK8A7W9fa?=
 =?us-ascii?Q?Tx/Z26IP+ZcUzIqrVi4fm6PsJXpECGIUiwOHblrrzjHBo5cQ7XcD8BIbiau5?=
 =?us-ascii?Q?55FEdxFFeLQZjjnolyWlAezFh7iDvEPvp4NYpCTRqzx8Oe2vzVmLIrvKD9Jk?=
 =?us-ascii?Q?e2KniokL/X0pN+B7MVeMA8MvvIwiB1+maD+LoZUWDi//zgc3yzKn9/Vp/2cW?=
 =?us-ascii?Q?nTuvGow4TX/fFz30iJMW44vg5wg2GENc/x5sRHaxiUqyGfwZkVmSGHR7/Lg4?=
 =?us-ascii?Q?9Pu0u+hRie8yhLhJyTuu+nFN51nWca8yiKBusd5/aBSMhaEGgpRmhUJqUJnu?=
 =?us-ascii?Q?c3eGj8rzhGNfUv3E9VfYDPkt46ogWJDO2MkyT1e+/Fk35eC/CituuUGkYBKK?=
 =?us-ascii?Q?OGSpinjNgIfKN3m3CXzkU/Zq4LbfAaIsdyXglcIFZI8c2kSLLuItKWQbLS9B?=
 =?us-ascii?Q?AL9nRM9mpcVWtGIdd0GrDyEEmnrHiNCH5MjSBU+Qm+oNC4j7boYV3R3Br3Jt?=
 =?us-ascii?Q?6bexSt/JY19K3jB3TkiA0tRmudg8/hBpN9ApYZcgj62SpHb+Gxy3xXvUs7DC?=
 =?us-ascii?Q?7ZpZSgoLtr1+lHQpIDENgKADmJgpdObEpFSZKEBc59nBa8zTWj+7DUEG3SEr?=
 =?us-ascii?Q?sL5wZxd7aU9aXiktR6Tp+I+fEgy2wB6xB1KXHFnrCb97f0ltEEk2LCU1svRC?=
 =?us-ascii?Q?vJqffMsH27R5HG5DoQ0dVrYAIphTlxoLWRQuyfE6xtx+06Fceamombp404Uy?=
 =?us-ascii?Q?1nI+IwyWkxztFlPXrf+tiOdhkBfGyFqmFlHzOJq/H3eqrw1ah/fM1odIHbTt?=
 =?us-ascii?Q?Lkio3o/iCQ9yh2cvgpXrlDkI6n70DehFyzMuw77NUuQgKNSzsrnIrEdhEB8Q?=
 =?us-ascii?Q?CNg4vVEfzMOAxVcZ/9xbVXlZB2k2ZmaEgKpmKSLSzzpsX9ms3EsT97m2gPIb?=
 =?us-ascii?Q?Zt54exbI54jIYMmAOzACB729LD8RlupQvBRYAmZwN2vVB7L51u3oCkg6TZ8+?=
 =?us-ascii?Q?k20wog60aYAe9tMC1PNCMoIgJ8En9R/RqAdZ69MxWgbCw3iRF3tayHg8Qm5t?=
 =?us-ascii?Q?30MDZA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e358a973-1d70-4dfa-f3f3-08daf218a3a2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 08:08:06.7348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ioN6KAPo8lxXwvMeXkfvc6A+NEJT9cTD1Bl2PxoZEOT2MqY8g16qA1iHj7PcADW+pPwPI310yhP89xllflNEBkNkfWJQI1LXlm295HKLoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4942
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 03:16:30PM -0700, Max Georgiev wrote:
> On Thu, Jan 5, 2023 at 5:11 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Tue, Dec 27, 2022 at 10:36:20AM -0700, Maxim Georgiev wrote:
> > > Current implementation of show_bool_val() passes "val" parameter of pointer
> > > type as a last parameter to print_bool():
> > > https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/netlink/netlink.h#n131
> > > ...
> > > static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
> > > {
> > >       if (is_json_context()) {
> > >               if (val)
> > > >                     print_bool(PRINT_JSON, key, NULL, val);
> > >       } else {
> > > ...
> > > print_bool() expects the last parameter to be bool:
> > > https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/json_print.c#n153
> > > ...
> > > void print_bool(enum output_type type,
> > >               const char *key,
> > >               const char *fmt,
> > >               bool value)
> > > {
> > > ...
> > > Current show_bool_val() implementation converts "val" pointer to bool while
> > > calling show_bool_val(). As a result show_bool_val() always prints the value
> > > as "true" as long as it gets a non-null pointer to the boolean value, even if
> > > the referred boolean value is false.
> > >
> > > Fixes: 7e5c1ddbe67d ("pause: add --json support")
> > > Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> >
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >
> > I'm assuming that val is never NULL :)
> 
> Simon, thank you for taking a look!
> Yes, the "if (val)" check on line 130 guarantees that "print_bool()"
> on line 131 is called only if val is not null.

Thanks, that is pretty obvious now you point it out.
Looks good to me :)

> > > ---
> > >  netlink/netlink.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/netlink/netlink.h b/netlink/netlink.h
> > > index 3240fca..1274a3b 100644
> > > --- a/netlink/netlink.h
> > > +++ b/netlink/netlink.h
> > > @@ -128,7 +128,7 @@ static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
> > >  {
> > >       if (is_json_context()) {
> > >               if (val)
> > > -                     print_bool(PRINT_JSON, key, NULL, val);
> > > +                     print_bool(PRINT_JSON, key, NULL, *val);
> > >       } else {
> > >               print_string(PRINT_FP, NULL, fmt, u8_to_bool(val));
> > >       }
> > > --
> > > 2.38.1
> > >
