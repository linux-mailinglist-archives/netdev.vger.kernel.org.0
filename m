Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DBF6BB886
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbjCOPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjCOPxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:53:04 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2052.outbound.protection.outlook.com [40.107.105.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCE67DD2F;
        Wed, 15 Mar 2023 08:52:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdOPePdeDWDjvRAkSfvpcB2v8Z+laka3dsinmtaIfm3Cb1enwotwTHWrK2iaVa5CWC43n189whE2p2ElFqB54ZU/pZf0RP+gghDVx3/Ope+BryjrtkYV90B1GoqC0URjGkVvwBl37oRB7F/Da67/hZn1TTPRQcTrPQUhgzpi3Gs9tPCKO20IX+V5K6VCOyCogIRI2aueu0YevPwPfwhIph5ZpZ55w9Qx5XCisCzf+M4qT+p+o23OWSoGCDeyMxaj1SQAgRY++uPfgNzoBMeRcF9PxmQh5zbGfN3PTgU6CG2RlCJbmbayjY2KmGboYTl0+PYiCo6YNWPE9aZppZQ6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXFxDPCUxaMBOOxN4qWNVG4CVB27fvpe5R5/hkEFOPw=;
 b=Gx09gZysjB5qh2mlk8CFLvnHzy2o8VuyYEcu85MAq8FmVEp1ipIa1Qci7PA+xNT8A5UKPD9icqBW8xCXGtoVQeAkePbO3f4IZLT9bOC2OoH2XcQveUs0t1WHD2UOJHI7cyj4J5wzmp7hqJ1XhaYxqIsL7dZJe15EgBPTTwUIoaLc5WjMhquWPJpwYd+6tj3xYCH5RgYHOOwR2Z/rdfvkHI3jXzeW7a9oJDaoy+5F/kzVzhIXZZpv5CYOb//sOebv+AteVrA1Oyihp4hiOhB0ifT3azaAk8ahaBQuJGEtEG9WgWAo0HHo2XvCC09MqNplnT1nqyHQictIETOpkVtM0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXFxDPCUxaMBOOxN4qWNVG4CVB27fvpe5R5/hkEFOPw=;
 b=dtipv5tob0MHNLTXWvvsTFG9cdqT1EjwydcgdCz/wPcyBi0m5vNjhdpd+I8PnviwT1HTrm9t2FXIzwcRlDwMolEi75Rs9tC3d5ouSpwKq1WC7J6YjjiSTcTTr3HdQvzsQ7pCHH0KLyfwDhymum+O4xlhvRUWROe+slX8NOXKZOk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBAPR04MB7301.eurprd04.prod.outlook.com (2603:10a6:10:1a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 15:52:24 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 15:52:24 +0000
Date:   Wed, 15 Mar 2023 17:52:20 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        UNGLinuxDriver@microchip.com, Ido Schimmel <idosch@nvidia.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Message-ID: <20230315155220.7bcfh2nt2qz77gju@skbuf>
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com>
 <20230213113907.j5t5zldlwea3mh7d@skbuf>
 <87sff8bgkm.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sff8bgkm.fsf@nvidia.com>
X-ClientProxiedBy: AM0PR10CA0017.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::27) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBAPR04MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c26882d-b076-4e8f-94ad-08db256d44d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYQ6htR/FRunvpxJ/aAOsHjZiUI3BubuXQp9qizzBbyc91C6teYb1nilEsLXNNxSO3LXdyKJgKwZa3ods1LTvq5RCOc4xTSuvz4a5mNMMrmJimhZETbRFA3vVMIMbQTLn1yIPU99t3Jig9tSoIkNYDCbHagiRORxZslhMM1XpPdqxqzLZBA7S7pgGndmUInSkGywDV78O8tZdaBYmuE0CmvGQgX1YzuadQLKpl205ZWx0SF6K6qty6PnfYBBpVRiHPKl+AVxx+2ZbRPJ0S27+QebwgkJ76cQzFIA/SkkBu36ZasiIQg60ftk8PSTkdDxdG3xJ0IMjo4WGh1PxNh9egaelf3tpV5m9Ng7bSFI/s2bgTl9HA6ocVNugOzP2+jc+lKqiFLD4I5M93tsg5+LI/i7VGGiC9ECWdI8+Udzrj7SQ1mvjHjsnto/0wZZXmoFR9fnOnk08cy0z3J1sgJhS6Z0t+9e4jCy5xjbZ+pKxovZ2dTRErsSC/zzE59e6InTUuP3H6AECpdnpVLE/kaCuWo9uCiGvEQmJucMShDoS3Rw+CfEMUdr7CKSXmpl+IBxcEykJORuj0duisqXL40IJkKuaMFbhq4s0ZbfvPtZu5HizFzeClNIV/dvF+myqSis7PhikBrdTczO/an8fG/exQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199018)(26005)(478600001)(8676002)(6916009)(7416002)(66556008)(44832011)(54906003)(316002)(66476007)(4326008)(66946007)(5660300002)(41300700001)(2906002)(86362001)(8936002)(6486002)(6506007)(1076003)(6666004)(186003)(9686003)(6512007)(33716001)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qXE6H32OYZVp+NuGNAgRtHmFMLukjNgw9uJPa4I7prvLXSlh+M18+c41ljai?=
 =?us-ascii?Q?HPHSrna+aD+LYQPZHmFq+xFTUgyJEXG4JkVmNLmcDSKTfuL34YMw8JvtJVvI?=
 =?us-ascii?Q?u2tPkMSoBcz4UBbdLkCOzIxGF7zqKGhN7xXgxzy3qFqDCyOIwkiSLBOUDOau?=
 =?us-ascii?Q?DLrvgG3IgpYRumF8b1156rU6MpqkTUx/4qBpZvf2QKaUQqNoLv3zCofrC9At?=
 =?us-ascii?Q?tRehvLRxMS2T+FOzvFyDQNgJ62vxsjVW4eWk7XG+GUwWwDn26VTrs1ry3LTK?=
 =?us-ascii?Q?2c8Go3QAvOwCRrOD916sx2mZQhcg4LC86ytlQ3w6MseHbW+EJkA1s9YFecTL?=
 =?us-ascii?Q?VPvTyGUIB2a/3YpM6LlBx1/0nfN1Ks4g5IgkblmSs0fNr8p61SnswZ9ZPlBg?=
 =?us-ascii?Q?i2bL/ed6w2S8utlCP2cFTbuyhqWxjf3orbh2DkquSOCV4USGwfvRnU/i2p/3?=
 =?us-ascii?Q?o1Z4zITNzeaugRq70AM5OG/8KrltvQQwmvGuu03n1zU8RNtaFl3BddDNNbdQ?=
 =?us-ascii?Q?4lIJBbfnQkB3U+OsuCKkrnZ1L0Dud+qjgI/wVb+Yf3X5Qq2AntxFa2US6Usc?=
 =?us-ascii?Q?2iJvmUwjU3J8RAMppZKINZpiHHTadU+lQaEB92aH6B1wjNojcZyozW02kpe+?=
 =?us-ascii?Q?bH/BPOwsY+6lH8iTrJzt//pTwfNeIpe7GhCoFxbQCUJnCbCrEvBEaEr/NGLj?=
 =?us-ascii?Q?Cs8RUdu+itsBRgKqDYcG1uGU9EuSNlbHAgRGqFYU7VO4/k+4rHH42K3vfoOy?=
 =?us-ascii?Q?2gBgbJCZzhGj0vJeZ3UI2+DoC9TQuqoMvaogi4QC/yHcorKKSKnhUZabdeh0?=
 =?us-ascii?Q?LSgdbmLiZ7EhpqG0Q2GwLbjVa72/SedCrx9L2XoIi/UYv8zMi+vIDBcwx7OQ?=
 =?us-ascii?Q?ZEHBnn2linXI4U0Yu48r8e9YjqR/+8eM7Td22WcdNbJHQhM3Dlip5l7s8iLQ?=
 =?us-ascii?Q?aElvH9DCJCGa419P6I96IQGM1kLyp8kWNtxnJ+aMm0zJT8R8Rhx7vOPhHAkM?=
 =?us-ascii?Q?fDVzKdlznRyON4aZZ6frzf6NEXuB2YmnlfSNLeaN2Pbzdi0PxIp2nZgDHN2R?=
 =?us-ascii?Q?wmxmeUfFcwUc15vCfg1a41IaunOyRSza5t02NoTzvBM1ZWxiFRkNB5R9CfyJ?=
 =?us-ascii?Q?QwymmScShnFJSsETCUGTj2/hTJdpWiUchh7azOP/kMiFOILGQs/C4oiGYFH7?=
 =?us-ascii?Q?Umbs86AfSBRjRDTRj7PElYJuLcJCDD9QGc5cnbDn4REEkLc1KSzgXTVB6vlO?=
 =?us-ascii?Q?+4eh+V/9wJUFN5Hf/htB7TLlTJOZDwnK9EbgwsETQixTzsDgsN2K+T8X8UeQ?=
 =?us-ascii?Q?P/0iK9y8tJTu/M+hoaFxlaet4rudEOQ8VUM4Lnq/p7f03V+RVnQI6v2I9sLg?=
 =?us-ascii?Q?pqqo5ouvAPW0o+a+mldkmH26aYM4H5cWjgoypd/0J0RgJFaEavlRTRPLAWmG?=
 =?us-ascii?Q?R4cdyD87CcPHAbcrUZmspBNsa6kauF5H7HD11P+MwDcIyiyJlyVswbzwCYJn?=
 =?us-ascii?Q?plLQ2B+S4W1O/La6Ydc2eiJ+LzRy6lLu/dHFLjjizoowdSS1BLWyeMVC4O5c?=
 =?us-ascii?Q?E/j9TQmIQQvKDdpZwiLvboR5tXAna8LUG6PL6ZdL5g1WiEwSslFDcQBiZkh4?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c26882d-b076-4e8f-94ad-08db256d44d6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:52:24.2445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EapULafLXTFl6hn9gROQtVUX5v46uzEbb3Q9He46Wd2uc9kyvG57H9JRzTs8YmCr8vjlvKtjWh3ZDdGaS0gPpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7301
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On Tue, Feb 14, 2023 at 12:53:06PM +0100, Petr Machata wrote:
> 
> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
> 
> > Hi Petr,
> >
> > On Mon, Feb 13, 2023 at 11:51:37AM +0100, Petr Machata wrote:
> >> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
> >> 
> >> > +# Borrowed from mlxsw/qos_lib.sh, message adapted.
> >> > +bail_on_lldpad()
> >> > +{
> >> > +	if systemctl is-active --quiet lldpad; then
> >> > +		cat >/dev/stderr <<-EOF
> >> > +		WARNING: lldpad is running
> >> > +
> >> > +			lldpad will likely autoconfigure the MAC Merge layer,
> >> > +			while this test will configure it manually. One of them
> >> > +			is arbitrarily going to overwrite the other. That will
> >> > +			cause spurious failures (or, unlikely, passes) of this
> >> > +			test.
> >> > +		EOF
> >> > +		exit 1
> >> > +	fi
> >> > +}
> >> 
> >> This would be good to have unified. Can you make the function reusable,
> >> with a generic or parametrized message? I should be able to carve a bit
> >> of time later to move it to lib.sh, migrate the mlxsw selftests, and
> >> drop the qos_lib.sh copy.
> >
> > Maybe like this?
> 
> Yes, for most of them, but the issue is that...
> 
> > diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> > index c6ce0b448bf3..bf57400e14ee 100755
> > --- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> > +++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> > @@ -2,7 +2,7 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  
> >  source qos_lib.sh
> > -bail_on_lldpad
> > +bail_on_lldpad "configure DCB" "configure Qdiscs"
> 
> ... lib.sh isn't sourced at this point yet. `source
> $lib_dir/sch_tbf_ets.sh' brings that in later in the file, so the bail
> would need to be below that. But if it is, it won't run until after the
> test, which is useless.
> 
> Maybe all it takes is to replace that `source qos_lib.sh' with
> `NUM_NETIFS=0 source $lib_dir/lib.sh', as we do in in_ns(), but I'll
> need to check.
> 
> That's why I proposed to do it myself, some of it is fiddly and having a
> switch handy is going to be... um, handy.

Are you planning to take a look and see whether the callers of bail_on_lldpad()
can also source $lib_dir/lib.sh? Should I resend a blind change here?
