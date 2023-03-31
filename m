Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3BB6D28CD
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 21:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjCaTqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 15:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjCaTqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 15:46:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2110.outbound.protection.outlook.com [40.107.223.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E93CC0C;
        Fri, 31 Mar 2023 12:46:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlIVaxyWIOhIIYgziAnmlbSaiOxmfXv8qXZEi6y6BjpTfjxmZPvw59dJU7sL3KzkXhIBnMB6GGU6agbm4NPR7n3Hb2otslLShx/ZEzzCJfaqCZ2NBX5kbRDqR38YOcoE+aifO5KG2slM9Wb1mkpck8biQUBDGBz8jH7WcG7QPV6IF4HBapbIxCF7/ZohXjZKx+TZC/at/KEjTXBxnZXGdxTPCMD/K+p11u61ZAeNKpohZK/kdRqPXw5silJOVWWsjRn6QgIGJyhAzl2UFSzRKwc4nu1/wXJ3KQz2aFq4Tpnvai9PF7VJhL2u7pTIoUlSXQ2M7ONgzavCDANaMbFEkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJgrFZ7EWZcriAAD+1jmmAai/4bg4fJ/8ey1rqCzgfE=;
 b=ltCbsOaHeIdaW7IKe2ryEr2BSVpkXGmeqSWWEfHiREAZHGNqWh5FCJ0cGu7+2f+8ru8uXmuHhF3JwN4nzgpLgQqDZaEK+THrf8ikkfh806HqeDvdulyM4S+awNjB0FjdbhTJYWHXcxOCK+gspqRiPSAidqb6g4o+ziSeqYF0wvtmJ2L2VFvzmdDV1vfJRGxjSo5IcBm83CiroRz60ybKl2Hub+IEfGUdqe+yR1jeV3brNdsyiF+yxbgF7q8rBYsee8uQgvj1ABSAo4/+SVjZrBAkhYVIY07ZNYlj+VhulkAj8xa+Kt9RkzJb6VA8cRpUJc7pNefCb6YKp/t0BlMeIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJgrFZ7EWZcriAAD+1jmmAai/4bg4fJ/8ey1rqCzgfE=;
 b=VB90K1wA/Ucjh2gvNvHH59a0UJJdq/rBPZpmf1sxGDVrbD21RSMRXHVBEMknLvxf4g1Rq+0Q65mUfQ/+HRgphzWbGXw6A3MUeTKDcs3kT9sqRc2OzIgLsu4Lp1WQOg8Fimz+aI/36XA91OntS1GR2irr7k7ylqVqZA4amIvt3Yo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3642.namprd13.prod.outlook.com (2603:10b6:5:24b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 19:46:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 19:46:42 +0000
Date:   Fri, 31 Mar 2023 21:46:33 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sricharan Ramabadhran <quic_srichara@quicinc.com>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mani@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Message-ID: <ZCc4mV9slbY1eVZl@corigine.com>
References: <1680248937-16617-1-git-send-email-quic_srichara@quicinc.com>
 <20230331080216.GA6352@thinkpad>
 <4792f5c8-2902-2e46-b663-22cffe450556@quicinc.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4792f5c8-2902-2e46-b663-22cffe450556@quicinc.com>
X-ClientProxiedBy: AM8P189CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3642:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b2582d-c780-4fc7-e6c5-08db3220a6d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mp9hKxZ8pdIoqoGO7a5eypltcyNgaijFObX3uPKvmD9ko7pb4DkOTh9MKuMzH2tfDx6uGUIosEUaDM9AS6hxrcBvetiO1OGme3WRJxcCWfAw4LnTELivlO51x8Ojjqm1IjjTdlBn+AuX6lBrz2peb3RBeOTGEam6a3t1NOP0+cZZwU92KDUxKtgFHl/VzZKrTwrwT4PsaTa42JQekh4cD1tLEcxCHbjTQcVkmFITFpNWTKgap02lHVR9C9v9uY/I4qMAl0KKQu6P62QiCdKtSXVlkgtV9WqVIOsfrIiKcYcEh6Lz5GH0+u81boPHUmv5zjsERjRq+/M0/t24C+G7FLk/FoozszGh0LUYX+3bLc1P9WO+EBau74aclEjdrEkPqcTGJgaJrlwIb85fXTz1aCcFgR8NMCJnrphTBjLYHMmOwcDlwMaoM/n3oSeczBA9rOLneQ7BOZmgATq4U1jQstVwS1chg0Jy3Yy7mBaq+QSMh239Srqwz6kY7qfs4oGUeD/pG+TdMw9lPsFG2aq5bgQk6NtAA93q4dByJ+Se09nGG/Iwx7BOZ9IM0F2tNkcutgyYJNWGEgWz08zGDXkEgWNfjYI04b2tKi/DTWZc78w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(366004)(39830400003)(346002)(451199021)(36756003)(83380400001)(186003)(6506007)(6666004)(2616005)(6486002)(966005)(6512007)(478600001)(8676002)(6916009)(66946007)(4326008)(66476007)(316002)(66556008)(38100700002)(7416002)(5660300002)(8936002)(41300700001)(86362001)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z3QxY4aSvy/xGfEc9i4MF1PAOqy40yVTX450Pvgx/J8XMOtHP3Ymz8cG1I7I?=
 =?us-ascii?Q?AYD6bw87+5XbKwyoR6mPKzgZ+NGrLnU+3jdESO5RVSZicO0lvTjsQT6sC5v6?=
 =?us-ascii?Q?SzTYkrLZEXR1PnwxxNJ/FwbBU7etC0Kge/k8WS6WUEfMUQcYFHq3TMJYDROS?=
 =?us-ascii?Q?B+4YyaX/ej8AuFHhNHmUn/W905N6ah2fDYYvL70kx0Cotm9ugg3L1ejow8dR?=
 =?us-ascii?Q?ckjHqJyWXALJ9worJCyh5/LOsTPCLNGJvDApkV9oQ0IxmkFQOAkwC1BNxsMA?=
 =?us-ascii?Q?vmpY4w8m8y7RqAVRUXBHFTF1ytOzZI9u5RNvzij5vxNjxtHmYi+Dd24yIewC?=
 =?us-ascii?Q?6LAswzuVVDj5ZU6Iw8Zot6zpy56zowjzszRe/c+yTOskRLc+jCeqiVmnvyep?=
 =?us-ascii?Q?4VleU8Z/miOs7lfhpty8p4t4lgZF8x3ZAg8sEBevYQIkP1qojrRvPjzLAl21?=
 =?us-ascii?Q?swSPtlDkGm09CffKqLzighHECsK8FKqwqCoXZVtbPAiaK4GwvtaTYYOsr/OS?=
 =?us-ascii?Q?yxExNRED7VIRv23G9TXWQb+Lw9TdU5Sort7TZccE3FUhGwfhbU9Me5rfOTP9?=
 =?us-ascii?Q?ObJFFikDUVl4eYO7mGgxTggV24iy8mye+VffUmC0WEG5zZS3L8+2E/8ExNqI?=
 =?us-ascii?Q?zvOwYKXStUNsOJIGeK3CSNjzvH3GebwEl3CVViaua9qjhg/7etK82G2ARQCr?=
 =?us-ascii?Q?OZUiOHzMfTgvtVmrvnwyjLF/teOR5Rg981njNt7AYya306kOuduT8cYe1TWW?=
 =?us-ascii?Q?c7irsDacolAKtDUiAb7+84z1zPC++2Wxcprc1QpmSciRfCw5kAP4Rlij3w+S?=
 =?us-ascii?Q?Q8eqOEgJqGbtUcuoxUxCddE1CW8gI1kGSu2fa1e6xKDjtj2a3XCI5UPaD+ne?=
 =?us-ascii?Q?WXOOt1Qpgwbf3atEiLv/hpeEKwetn+6LnoBrG8U89+Gjedgzb6OJQ9UoxnBz?=
 =?us-ascii?Q?bEg77y960ZbO49m6Npltn24rCUou7khZ6LpTWCCF3iw9w4wYwh8uqfOsmMdM?=
 =?us-ascii?Q?jXSjCtvW4Ud7JYXNP27H4qj/DH+CAqmuazwNVay0m79iayeH+qeXixkRRBYj?=
 =?us-ascii?Q?WDfyw0v9tEYN+M4Itq249i79NMXd92zecbI4zft7HTrUmhmp6681n45A3o9i?=
 =?us-ascii?Q?dN+Mw38qh1h9ovamUKTynmUlPzu/pCRv+PapfTP5WWWFjhZnV6VB++bPMhz1?=
 =?us-ascii?Q?CTw4jJjHxl5in10MbZvnhrXc98bJOqWzRR8wvr6ef+4JF8w3yEkZU6nqrRvc?=
 =?us-ascii?Q?Kz1UxQl6UZURzy1Bcr5+/Df5XFmWfs0OKak5g4WHZNx35Ujkx6KjRVv5I9CQ?=
 =?us-ascii?Q?GgNUEmF47nITTD/E+NaG3YWj6tZQTwxYNXLVzLT2l/zQX9upyvPaMtbEef2E?=
 =?us-ascii?Q?aTlggPIEupMacTxU4xknG5+52cpTX0dfp94Ghaj8ImOXmujlIItBfq9Bk3zm?=
 =?us-ascii?Q?syb9YIoVDNlIDaZYtssJXBQwB6iwfztt/MPBlPjv7yPH9pMqK8EeA+S+NiEm?=
 =?us-ascii?Q?drg7xF3Xv32rsJzo9eYSvXUZdfLEEP64xj57fxkHaax7D4yeYwD6u/thgylR?=
 =?us-ascii?Q?kgETpnuu8odU6OXPraa+bAy1w3Wi+nYB2PNlXWHIXI6LE0irg6URsKF5AvB+?=
 =?us-ascii?Q?SCsd4WkPKAuokt1l63cPdgvTUUWH7QsDC70LI7E3/+erqlyB4jAB6gUyrlts?=
 =?us-ascii?Q?IQ4fBQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b2582d-c780-4fc7-e6c5-08db3220a6d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 19:46:42.5041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9poQJ6+dJoH8foi15DkLlBwVkhYkGwrhMyzc/IMmtIJ03m5uhU3H1iV9WaXG8qExaCf1d/zehaNdO3o9/5xDoxV05P9SRzLIGUjYs04GD7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3642
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 02:02:04PM +0530, Sricharan Ramabadhran wrote:
> <..>
> 
> > > -static int server_del(struct qrtr_node *node, unsigned int port)
> > > +static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
> > >   {
> > >   	struct qrtr_lookup *lookup;
> > >   	struct qrtr_server *srv;
> > > @@ -287,7 +287,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
> > >   	radix_tree_delete(&node->servers, port);
> > >   	/* Broadcast the removal of local servers */
> > > -	if (srv->node == qrtr_ns.local_node)
> > > +	if (srv->node == qrtr_ns.local_node && bcast)
> > >   		service_announce_del(&qrtr_ns.bcast_sq, srv);
> > >   	/* Announce the service's disappearance to observers */
> > > @@ -373,7 +373,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
> > >   		}
> > >   		slot = radix_tree_iter_resume(slot, &iter);
> > >   		rcu_read_unlock();
> > > -		server_del(node, srv->port);
> > > +		server_del(node, srv->port, true);
> > >   		rcu_read_lock();
> > >   	}
> > >   	rcu_read_unlock();
> > > @@ -459,10 +459,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
> > >   		kfree(lookup);
> > >   	}
> > > -	/* Remove the server belonging to this port */
> > > +	/* Remove the server belonging to this port but don't broadcast
> > 
> > This is still not as per the multi line comment style perferred in kernel.
> > Please read: https://www.kernel.org/doc/html/latest/process/coding-style.html#commenting
> > 
> 
>  Ho, i had it like first style and checkpatch cribbed. Then changed it
>  as per the second style for net/ format. You mean we should stick to
>  1 st style ?

I think that what you have matches the preferred style for net/ code,
and thus is correct for this patch.

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#multi-line-comments
