Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B43D6D9723
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbjDFMmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 08:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjDFMmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 08:42:17 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2107.outbound.protection.outlook.com [40.107.243.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFC47A8F;
        Thu,  6 Apr 2023 05:42:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNtTkiDtqSyTQBU+ec93XYdJ8CCQ0LSjUkoW8iQ3qISKJYceZZJ2o5a/naVJIY9otKUBi2prJEdcevOZl0yjTg7BwyXTo1DHJVUFX3j/THrjRWBE0Z47c03K59RxeNQ6XD4E3WfIznyyR2BpkeH4AQQUnmGWoTJY8O2NrGlvdSxVGe71M7zm9Ribn7g4FdiK09L63rVhw5MOAFX84dI5U6TEJbRDhrWk9AjGgPTeJginCAprWuDie0Jwoxn9MBfVNMFo9cZ5tvYDb6xz5u1tvRd/JQuKcAqndAUGLr2NnyBD+pbqnOg2F16twG4JTDiBCTJgRPzrClb6npu9Udhsyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oW2ON1ierCIsM1FfiBE3VUMbqPZ6cWa8afrcPq8UNUw=;
 b=hFEArNzUYXnCGm5Qh3TTZmVYYLShm+C20EmpKr/K8wugK6aPsc9WJ0OiZyHTmrbbFvhL+j6TG6G8qNroZTlrkeW/0n8VX3To+BR1I/nOQX55zNR1OPgXSAVIWuJmEeqXsYFsQNNT5nA2ivvdnJUBFf2evk5qY8MCARoHKfvD6DEqrqnZeYxpo0OPrngH+aqSuw7ZLwYmhLIp2nDINBl6qDCCC5kOK/2n0GmqanU5bviJVmpqffpFdSN3SViYTt9J3IYYLpLYJTQBSE7ZSh2b1oX4jUzV+EEoNBZxPeT+MeyGpJQVEDq+d/r9Y1hXCzNRySkpr5Hel3FV31CGNVgCRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oW2ON1ierCIsM1FfiBE3VUMbqPZ6cWa8afrcPq8UNUw=;
 b=T+e0PpN3G9Pyo74oCesJwAEpsi08JyyEWgSFeWzTY/NXHGxFksVXk/iUZ1iImtWHcxxkZ8p8X3LCBKtbrf80Aap+De/xi8QTRdsQ7V49nrzVW1eK4GzUV5CEJcCGvJgVutlc5lPu3x8FZwHyfbFYYxDqwwrw/JVxs0Uxu5TQUTc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5974.namprd13.prod.outlook.com (2603:10b6:510:16d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Thu, 6 Apr
 2023 12:42:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 12:42:12 +0000
Date:   Thu, 6 Apr 2023 14:42:06 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] qlcnic: check pci_reset_function result
Message-ID: <ZC6+Hv0mrnGlsMpk@corigine.com>
References: <ZC1x57v1JdUyK7aG@corigine.com>
 <20230405193708.GA3632282@bhelgaas>
 <ZC5uyOt7mevNyS6f@corigine.com>
 <32f18da1-eeb9-3cd6-398d-77f76596b7c3@yandex-team.ru>
 <ZC6wakoBhc1kxFVk@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC6wakoBhc1kxFVk@corigine.com>
X-ClientProxiedBy: AM8P189CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: bb12587a-7bf2-4789-693f-08db369c5828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhBb22/PTk0bUmOFFxOOqEOHNyXbQHbds0U18PP5c+kD6WoSmOQtcTpKUJq3cuVoMdLmV8OIKE9vw7hC44+t4MwAKX1Mvi8xcvZZmqar4rRWBjlPbv46cxzLLdWIv8mX/G6rJ8pquthkppPdrPPKiRUecT7pammD8ip/1Wrn6ZmD2zH2gheiM/5xRoWO5OlmuGqiiKtiCaZiXuVrJJ0lgynxbj81YWDiV0V5KqtsjcLSDUeIpkeaY2JlnZgN2Lg4tL6m3lO4jgMwnnR35LYJl1v91EodA2mYpwGn9A3UAGARrICAHTftFV+S2X5UikPz6gCxKPM/wTr2xorsfq5IKgyqPwUm+9h594S1FAZAhPS/i31lQKaK3cVMcLLrj5ggX0rHBLxshoQivx+NbzolYyR+R0jjzGRU8cLBAuPI+M+qSFqloGF28gO4yu4tlI0+0RRlSd3KzxK+4Fon2JpJRT3fYyESU8BXUX511fWVCGecdrZKChvlh6w/tQ/41XQ2X9a8yIMVqdfSxShkIDyARnIBHxSfdHch+C41mVzhO2rcJ4SpG/8DZjpZIyRpbqSWOoAMNOqBQiAhvG5FphfJ8HyUyJeeCQi+v9xti1MZX9M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39840400004)(376002)(346002)(136003)(451199021)(41300700001)(4326008)(66946007)(6916009)(316002)(66476007)(66556008)(86362001)(8676002)(8936002)(44832011)(5660300002)(7416002)(2906002)(36756003)(186003)(53546011)(6506007)(6512007)(2616005)(83380400001)(38100700002)(6666004)(478600001)(54906003)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AJMkzzOIts0pu8nx76YGAoT8MYKTEJseZoFKyJQyyt4SwXIB2Sgdu0FHY5Ch?=
 =?us-ascii?Q?TY5oUny4GC20WKA1/cWTnCg7KEcHeUqsdLg3LvKDqpEvT17AYxm0R06FWiyh?=
 =?us-ascii?Q?SG3yc9w9EWtvVjp898S6q38CSnH38txQa+6LoXH8b+nWCDNvPLIe70ihtAQz?=
 =?us-ascii?Q?KsK7FIIq4TcKLEIMlJdpjrU5DMFrJFUOfo1K9IZMAsPENMqhuRyhcVGeeThy?=
 =?us-ascii?Q?/prI9R5F7Q7fgUZrZoiDqcm387dNQLCusAxYHvisQvINOdxn9Wn/+usebAf4?=
 =?us-ascii?Q?tCUrb/pwnoDoTn+1eAomo+R9yFliSBBZrpPnb1u91avc1mTSDedPFKsxqm8S?=
 =?us-ascii?Q?fvnwXmHstRJ7ObR6822PqqerBndMATtjTq2NaGaCa2FJA4OlGS0qoZ9H+WBo?=
 =?us-ascii?Q?Z0I/AYgyU5+vco8MOTrBplKMo97Cgsmrk4LACKFeTudUwV6jSEtiZ713oRRP?=
 =?us-ascii?Q?xVLi6KTZzlSAIiwX/tQzDqefmLQAaQ+1qFf3U5XRL2UjAUJdL/c8NwdXhdiD?=
 =?us-ascii?Q?Fg7AVFaKDtOwUViHr6wu0nPuEeCXNoRwzQfDJiYHtx4tFJgbccNz/dfPJOt7?=
 =?us-ascii?Q?+8vprlp4YQLLcN3RmGleNby9BXBLxajbRqu6XgWvrtIP7ertCTLi22FMKnN/?=
 =?us-ascii?Q?nANTHX7ffeG0AOA5opa38R1geysdNYTDvq29TQ5XY3mQNpJJUZX+2ucywq4s?=
 =?us-ascii?Q?ZA5bPODSSA1ZAjHqrtvIgrzCPtjq1pQj6wBAKaLq8u+gsmm8xi8WSnyNN6E7?=
 =?us-ascii?Q?c0eMAb5eVkBRde6MRqr8AO/zUsS+kuAslgecaokabGDDZdaytGoZr4z8paSX?=
 =?us-ascii?Q?GfCYpuVGEFMM3IfeaH8s0MBJ7GsxlBLDUDRBZrkxr8wtCAGcVD9entqXlvSR?=
 =?us-ascii?Q?SPBhEGh/ifHd2gEmQ+TiKLml/e7EdIgZThttSYQdOMmzIwCoaMzo8e389nTU?=
 =?us-ascii?Q?1lms1jqnUSAFeAupY2hqmck/EPkLa6acWB9BNX2nRZKpnf4Etpxb6zGBjpfj?=
 =?us-ascii?Q?uUK6efDcIhWJRGwuhO2TqBg4sNlBW0Qtp83GGl78Lws7sCrmN1JFJyuIb3wb?=
 =?us-ascii?Q?q0Oye73AXcrgD6iWhnbzmEk9hzdq/FhDINvhosaXa59PXWqsbkTzsiJjId5s?=
 =?us-ascii?Q?LoDnjdI9KAlOTzox79bbyVw7EINN5qMSAGtaRQQKPc4ErywCV2Yq4b9xRIn9?=
 =?us-ascii?Q?5tts4dRkMi9GoAfUCTaCIF4NyDnELJATTp1sVJucpf6YNpbAaGEt2gCkCvxO?=
 =?us-ascii?Q?4zKOopdgWLofkY8+Rb/2TJ8nd2iO/LGm/JlOPgd2TbNJdXcFSrptg04vW5jB?=
 =?us-ascii?Q?Gj1aJztO0Qoj4KF8MwUU0aZU5bcFOPXICXz8JJiuzAo7hyYI6W/FY3EYdNsq?=
 =?us-ascii?Q?Qhx05aoSZm5a9lh39fYdkBR5shPR8KaCo+yn2JWFOCDwn6WFGcm4CSLmqknA?=
 =?us-ascii?Q?wsNv8hqWui1+Wc417rAxqFtGnryXXmwAtazxFGxnzkx2aE3/nlvIoHSqna6A?=
 =?us-ascii?Q?P7koQtoWq+Jsn/ganCtw+zPf1yUB+aecJ1wmvDMFSFektZBLXRVZxtd3ooH7?=
 =?us-ascii?Q?93Ek6iE9v71LWDGEzGSfi2D6sjEQhgg1uTttNLmoxiWdCHKOzwrZq7ZnB8ER?=
 =?us-ascii?Q?znBhvhrzIy2AzTXXxejb1EKUNwd9dajkjycEIGrwt9qfvRBspUrAk4K3YBvv?=
 =?us-ascii?Q?XYkUXg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb12587a-7bf2-4789-693f-08db369c5828
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 12:42:12.6438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDdN1XvU1rUrXjDlUMcuoXM5vmi8dpf9vrYh8CZKhlexsULCVvUmUeAEz0zAXaTNmlaeAfNTFyF67o4s3BiLie3ImKVAHPDgt2fHsCwKMNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5974
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 01:43:44PM +0200, Simon Horman wrote:
> On Thu, Apr 06, 2023 at 12:23:49PM +0300, Denis Plotnikov wrote:
> > 
> > On 06.04.2023 10:03, Simon Horman wrote:
> > > On Wed, Apr 05, 2023 at 02:37:08PM -0500, Bjorn Helgaas wrote:
> > > > On Wed, Apr 05, 2023 at 03:04:39PM +0200, Simon Horman wrote:
> > > > > On Mon, Apr 03, 2023 at 01:58:49PM +0300, Denis Plotnikov wrote:
> > > > > > On 31.03.2023 20:52, Simon Horman wrote:
> > > > > > > On Fri, Mar 31, 2023 at 11:06:05AM +0300, Denis Plotnikov wrote:
> > > > > > > > Static code analyzer complains to unchecked return value.
> > > > > > > > It seems that pci_reset_function return something meaningful
> > > > > > > > only if "reset_methods" is set.
> > > > > > > > Even if reset_methods isn't used check the return value to avoid
> > > > > > > > possible bugs leading to undefined behavior in the future.
> > > > > > > > 
> > > > > > > > Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> > > > > > > nit: The tree this patch is targeted at should be designated, probably
> > > > > > >        net-next, so the '[PATCH net-next]' in the subject.
> > > > > > > 
> > > > > > > > ---
> > > > > > > >    drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
> > > > > > > >    1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > > > > 
> > > > > > > > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > > > > index 87f76bac2e463..39ecfc1a1dbd0 100644
> > > > > > > > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > > > > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > > > > @@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
> > > > > > > >    	int i, err, ring;
> > > > > > > >    	if (dev->flags & QLCNIC_NEED_FLR) {
> > > > > > > > -		pci_reset_function(dev->pdev);
> > > > > > > > +		err = pci_reset_function(dev->pdev);
> > > > > > > > +		if (err && err != -ENOTTY)
> > > > > > > Are you sure about the -ENOTTY part?
> > > > > > > 
> > > > > > > It seems odd to me that an FLR would be required but reset is not supported.
> > > > > > No, I'm not sure. My logic is: if the reset method isn't set than
> > > > > > pci_reset_function() returns -ENOTTY so treat that result as ok.
> > > > > > pci_reset_function may return something different than -ENOTTY only if
> > > > > > pci_reset_fn_methods[m].reset_fn is set.
> > > > > I see your reasoning: -ENOTTY means nothing happened, and probably that is ok.
> > > > > I think my main question is if that can ever happen.
> > > > > If that is unknown, then I think this conservative approach makes sense.
> > > > The commit log mentions "reset_methods", which I don't think is really
> > > > relevant here because reset_methods is an internal implementation
> > > > detail.  The point is that pci_reset_function() returns 0 if it was
> > > > successful and a negative value if it failed.
> > > > 
> > > > If the driver thinks the device needs to be reset, ignoring any
> > > > negative return value seems like a mistake because the device was not
> > > > reset.
> > > > 
> > > > If the reset is required for a firmware update to take effect, maybe a
> > > > diagnostic would be helpful if it fails, e.g., the other "Adapter
> > > > initialization failed.  Please reboot" messages.
> > > > 
> > > > "QLCNIC_NEED_FLR" suggests that the driver expects an FLR (as opposed
> > > > to other kinds of reset).  If the driver knows that all qlcnic devices
> > > > support FLR, it could use pcie_flr() directly.
> > > > 
> > > > pci_reset_function() does have the possibility that the reset works on
> > > > some devices but not all.  Secondary Bus Reset fails if there are
> > > > other functions on the same bus, e.g., a multi-function device.  And
> > > > there's some value in doing the reset the same way in all cases.
> > > > 
> > > > So I would suggest something like:
> > > > 
> > > >    if (dev->flags & QLCNIC_NEED_FLR) {
> > > >      err = pcie_flr(dev->pdev);
> > > >      if (err) {
> > > >        dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
> > > >        return err;
> > > >      }
> > > >      dev->flags &= ~QLCNIC_NEED_FLR;
> > > >    }
> > > > 
> > > > Or, if there are qlcnic devices that don't support FLR:
> > > > 
> > > >    if (dev->flags & QLCNIC_NEED_FLR) {
> > > >      err = pci_reset_function(dev->pdev);
> > > >      if (err) {
> > > >        dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
> > > >        return err;
> > > >      }
> > > >      dev->flags &= ~QLCNIC_NEED_FLR;
> > > >    }
> > > Thanks Bjorn,
> > > 
> > > that is very helpful.
> > > 
> > > I think that in order to move to option #1 some information would be needed
> > > from those familiar with the device(s). As it is a more invasive change -
> > > pci_reset_function -> pcie_flr.
> > > 
> > > So my feeling is that, in lieu of such feedback, option #2 is a good
> > > improvement on the current code.
> > > 
> > > OTOH, this driver is 'Supported' as opposed to 'Maintained'.
> > > So perhaps we can just use our best judgement and go for option #1.
> > 
> > So, it looks like option #2 is the safest choice as we do reset only if FLR
> > is needed (when pci_reset_function() makes sense)
> > 
> > If all agree with that I'll re-send the path
> 
> Yes. Maybe wait 24h, and if there is no further feedback go ahead with that
> plan?

Perhaps a code comment, or the patch description could include
some information about the reasoning above.
