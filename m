Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED906D9661
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbjDFLxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238503AbjDFLw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:52:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20730.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4018CA0C;
        Thu,  6 Apr 2023 04:49:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aid5ShKKge7acoa8BmGImmYuNrn/+8GZFMFt7ckWNlqlpANkUtdiLpP9dtRLfaRrefWXpBNqdVZ+aolWdoiAxBOgwz9aHycCwPI8mMHzb5nl/2PBdXUDuo9yyry5aTI9+exdeR1pN5J9fJyXVQ3SyX3CqpZKlyTx+8qHedRQRoQ+s1EFtUJkV+e097seRQXUIdXZRCj760JI6s2aeZRvynnD4ur4tPyF+5kyvtDPSlPoBj6Ljw7/WWHQLHmEhqxoNZkHyr+J7ZUqjv+Y801Z081rlNnxNEF0gU6dWC6FamhWQ3ziPV+KtT565m4zx+G4GRowURivRnbuLnXQzXRVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vt3+vBJQEvm83Usj1CpjUMoAN8wwHkysLEavoiGZjmg=;
 b=kW3P+V5GL7zAJOBPXqu3Qp0OGjcB7UiC9T/dcyVTT7Jn8mZuvvTPlU5Jjsa3hgjbdvCqzljxwqYIc/KtO8JmaSMnfbz74fu4RBBhoCgJsiz5gcig4028ZBbJnvlsFq6cKRTR4SAj+CA5GypM2avkwW6Bot2rRyiIqlnJvTTbTxwbS7vk28q7Qa371/VygiWTbiMLZcVo6fV+5050v+xIxfSKXj1mKZCmuoQZq2i7wcZTKJYz8G8Wbir+K4eK4XnN3zVNsMp9xRaJtdF2UXMnCUbiAoSQrD7P7dIYBhoyo3T6igKkNs8fUzkVc2fVfbS5qcFru+xhMzDym8lfU9lmHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vt3+vBJQEvm83Usj1CpjUMoAN8wwHkysLEavoiGZjmg=;
 b=t8Hyg4/KFI2ThB+CTR/RbY4XQPHqNiNyjt0M5uSQcTuKAZ+g3+Uy7613L4qVxsrQuUMt4EGp1BOk28jrphoYv5Uq4H5J8/71RiUGCPlR5w/LELdm7u9Q6N0NtW93QfqJf/H3BGLDuZqN5t6W4t+XceQyWTb5+SHvSZtpMNqVyB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5553.namprd13.prod.outlook.com (2603:10b6:303:180::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 11:43:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 11:43:44 +0000
Date:   Thu, 6 Apr 2023 13:43:38 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] qlcnic: check pci_reset_function result
Message-ID: <ZC6wakoBhc1kxFVk@corigine.com>
References: <ZC1x57v1JdUyK7aG@corigine.com>
 <20230405193708.GA3632282@bhelgaas>
 <ZC5uyOt7mevNyS6f@corigine.com>
 <32f18da1-eeb9-3cd6-398d-77f76596b7c3@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32f18da1-eeb9-3cd6-398d-77f76596b7c3@yandex-team.ru>
X-ClientProxiedBy: AM3PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:207::19)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fb19f85-0586-4718-5865-08db36942d2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tyyZWM/zPuZbJmAq/iardM0U5i4pm4I5erBTmGFp0za2p1EFI4aofTA99x9R/XAXNpA4Y3qg14JU60SEqiPHYoDbger8LzvN0ez9yR4F6rKslQ6ahOGeDNNX71LsPa1cDDPs5ZPO4c+798PC43c8HpqgXXU/b/1s7w9uYG/zcc50Q+F4gA9m5inZnaX5Ugo73vPkfCCHu/KqJ/+uSVhR/40551UAHz1TLKQi0ZatQ8BmVGeCppc9HB+nFLAc0NMPCZOKbYSpubjORciC1l+VHXVt2qLROjn72sP+lMzqP29Y6bHrXij2UpUrMv0gVgtKHotMgDLDOVp2XnTGO0R1VgP6/P3H8CFDq0ue2aBPHOIf3Y/vehdgY2wKIbybeMWZP8lFSOTFKA1TZ8abOGBim19IaU6pb8vj4UPla4kq4y2dveSUxAMFqOXeBQIgMBQHAGQ05nsQ4qHGvlfD+GZGlSzL6eDwl2QF/6+Szc8/RnSto2aSiUIcTh5MiudlpetjhYe66B57YDshfbj8qIWLrO1cAw3jQmpPw1LZD4fy0hyJ/DNH36IqPD8pZmsGvFs5XMX8j3FomqQyzPpyQ3bKMel4TH0pYxF4l1ifQnLfwrI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(346002)(39840400004)(136003)(451199021)(44832011)(7416002)(5660300002)(2906002)(83380400001)(8936002)(2616005)(6666004)(53546011)(38100700002)(186003)(4326008)(66476007)(8676002)(66946007)(66556008)(6916009)(6512007)(6506007)(41300700001)(36756003)(6486002)(316002)(86362001)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mXZlC4PkfyC6DTjvq/OuEroKVybDD361IhIlyyl4G7gbYuj7cVWPnx9YiMhm?=
 =?us-ascii?Q?d7ycJg3oqEOPI53kiX+Debrupf36H7vLNb07mbSwuQVEsCAoMcS9Cen2PiqE?=
 =?us-ascii?Q?Vo+G1fDPYhx0ivqnoQciMgcGJSAVB4f2aWJ8+yTQ50abfT4UvtXsqfEL4K/3?=
 =?us-ascii?Q?lTpIZrhRH28wqLFLYRKlr2WcAS48vOJS0bad5GTgtXLpJu75AfxAzqcOVm17?=
 =?us-ascii?Q?YHypeN0qWtRSR/ycomR5ux7o0rqC0Me+C/x8u0tpdMkoAuWDXS1ObPnZ2TX3?=
 =?us-ascii?Q?ytYm7of/8HDVXOjblDDPk0UznN8H+rhyDcdjffyqNI2y3O1PnvcVmjFRv9LV?=
 =?us-ascii?Q?vxdXGtEWMVqxVRtpYBtyL25wD8iQs3krr7gyhfSc4eL4wttjsm+x1uLWOXyq?=
 =?us-ascii?Q?a3lBefOPErfxHnZexweDZQCp8MqkZjvHSmkD/sAg1UesBcT/UqmclnmuzX1t?=
 =?us-ascii?Q?BDnZxrea0uQV6CHdq96KyAlP9qqA9tQnp5Fw8vrrcTJnMJXHTqYmPgni38ht?=
 =?us-ascii?Q?cY6DcNQpMuI3kyGGN7Fy8PUjSciC5k2xWfh2le2InA2dpqw/XnpyiUfjULwE?=
 =?us-ascii?Q?cLUR5fv/li+CVNqwtjMJ18WOHIXjU/HMnWzXZJ43p9Nx3vIohxL11BdJTcPR?=
 =?us-ascii?Q?ZE7GL4YcrrBD7U1hGUciYz6l2i1GLDvBCN3X5+/oxz5SKPrMXur4Ygt3gQb+?=
 =?us-ascii?Q?BWN9N28tbEELyxs+atvEMhjRS6cCeaTcbo4lT1yYF5cf3gecMEC919RMp0ar?=
 =?us-ascii?Q?vIodo0a7wboxxstCxSW/kPB1b7Wa0SofJ4WM2oT1GgKhIHSQskhbRShT++9c?=
 =?us-ascii?Q?RI9o3BXGLZOfRPZE9Wx3V1z2aHqthnp5u1GpBAxyyw7Bl4vTIOAHXLcXpQ2w?=
 =?us-ascii?Q?TbnPh2JQ5JzEUCPhTFAw2lkfbCSKYBH2izJhHRH7UtmehC99kii/CTd+D9AU?=
 =?us-ascii?Q?dDl9H5Vnoud+qiZ0uLMN1g6UOH9VdrzPeGUd5MBAK8B479vO4GHVzOIUGAKz?=
 =?us-ascii?Q?hD6zN28Lib3E6lVkfHM8ABEyk0zl7mEpB6ChJKMXhTD8YdkMG1keDvOUD//B?=
 =?us-ascii?Q?2Gr7Ux0wRgdp0+vAQ8JM17AvxLPqPJmuCSU45HEj4Uz237vkp2OgXK6WqF7O?=
 =?us-ascii?Q?DRdL3g5JyaPMkR4Km+go8WLDxaP5lMwa2feDsrQV8lwkt6myJhOwiRsy7rvn?=
 =?us-ascii?Q?690Q+LZJ+B9Ti1YCX2LTOCcS1rcNvIVFt5to7ALl5LSqdubxFP70tANRUich?=
 =?us-ascii?Q?S6lP5e/E7d7u+N6Czvt+lxb8WEzslSFdtNgrQ+UX7LPGud2izfkiiHhNJFcm?=
 =?us-ascii?Q?w6PTUTH/FTgu8gIIu16rq7O4dKlh7zgivF3P+86bCw0ASWEU2uoCSlaYoTTw?=
 =?us-ascii?Q?7uiEFmzbauR+tFvd+KrP+CYaifntxmZDkn52/sQU/mAQ1DzYOZdjZEmdY6k1?=
 =?us-ascii?Q?j2HlqqN7tPlIWwZcVfaPNUpehkz+IRote0AYP8bDLJA7t9M1jVPOFOyocG70?=
 =?us-ascii?Q?+raVm+pDionh6JG4BSSivZ4h2PJS8dUbvvSOobCGwaHS+KcVUnevxa+4TrWS?=
 =?us-ascii?Q?SK5dvbEHG+NuGKkRh1/+7vzHggptR7PNfwMyVVPkId0KawXwwi/DXk2Vtb5z?=
 =?us-ascii?Q?hdHp/868tsBPDyt86HAI1RmGaIh/SJfKB3OfF1w8nfZG57m1bl4Gg8oI4Vxt?=
 =?us-ascii?Q?dI2giQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb19f85-0586-4718-5865-08db36942d2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 11:43:44.5986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8Gnksp58zMx+wS4OQkCLBlrM00q7HVPN+2wQO0LbWj0h8BIsg8CnDq10m0KYm0hl5g5zvrdGDrv+MnwKYndnPLTJP4mYiMsFuwqXL5M0kk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5553
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 12:23:49PM +0300, Denis Plotnikov wrote:
> 
> On 06.04.2023 10:03, Simon Horman wrote:
> > On Wed, Apr 05, 2023 at 02:37:08PM -0500, Bjorn Helgaas wrote:
> > > On Wed, Apr 05, 2023 at 03:04:39PM +0200, Simon Horman wrote:
> > > > On Mon, Apr 03, 2023 at 01:58:49PM +0300, Denis Plotnikov wrote:
> > > > > On 31.03.2023 20:52, Simon Horman wrote:
> > > > > > On Fri, Mar 31, 2023 at 11:06:05AM +0300, Denis Plotnikov wrote:
> > > > > > > Static code analyzer complains to unchecked return value.
> > > > > > > It seems that pci_reset_function return something meaningful
> > > > > > > only if "reset_methods" is set.
> > > > > > > Even if reset_methods isn't used check the return value to avoid
> > > > > > > possible bugs leading to undefined behavior in the future.
> > > > > > > 
> > > > > > > Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> > > > > > nit: The tree this patch is targeted at should be designated, probably
> > > > > >        net-next, so the '[PATCH net-next]' in the subject.
> > > > > > 
> > > > > > > ---
> > > > > > >    drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
> > > > > > >    1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > > > index 87f76bac2e463..39ecfc1a1dbd0 100644
> > > > > > > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > > > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > > > @@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
> > > > > > >    	int i, err, ring;
> > > > > > >    	if (dev->flags & QLCNIC_NEED_FLR) {
> > > > > > > -		pci_reset_function(dev->pdev);
> > > > > > > +		err = pci_reset_function(dev->pdev);
> > > > > > > +		if (err && err != -ENOTTY)
> > > > > > Are you sure about the -ENOTTY part?
> > > > > > 
> > > > > > It seems odd to me that an FLR would be required but reset is not supported.
> > > > > No, I'm not sure. My logic is: if the reset method isn't set than
> > > > > pci_reset_function() returns -ENOTTY so treat that result as ok.
> > > > > pci_reset_function may return something different than -ENOTTY only if
> > > > > pci_reset_fn_methods[m].reset_fn is set.
> > > > I see your reasoning: -ENOTTY means nothing happened, and probably that is ok.
> > > > I think my main question is if that can ever happen.
> > > > If that is unknown, then I think this conservative approach makes sense.
> > > The commit log mentions "reset_methods", which I don't think is really
> > > relevant here because reset_methods is an internal implementation
> > > detail.  The point is that pci_reset_function() returns 0 if it was
> > > successful and a negative value if it failed.
> > > 
> > > If the driver thinks the device needs to be reset, ignoring any
> > > negative return value seems like a mistake because the device was not
> > > reset.
> > > 
> > > If the reset is required for a firmware update to take effect, maybe a
> > > diagnostic would be helpful if it fails, e.g., the other "Adapter
> > > initialization failed.  Please reboot" messages.
> > > 
> > > "QLCNIC_NEED_FLR" suggests that the driver expects an FLR (as opposed
> > > to other kinds of reset).  If the driver knows that all qlcnic devices
> > > support FLR, it could use pcie_flr() directly.
> > > 
> > > pci_reset_function() does have the possibility that the reset works on
> > > some devices but not all.  Secondary Bus Reset fails if there are
> > > other functions on the same bus, e.g., a multi-function device.  And
> > > there's some value in doing the reset the same way in all cases.
> > > 
> > > So I would suggest something like:
> > > 
> > >    if (dev->flags & QLCNIC_NEED_FLR) {
> > >      err = pcie_flr(dev->pdev);
> > >      if (err) {
> > >        dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
> > >        return err;
> > >      }
> > >      dev->flags &= ~QLCNIC_NEED_FLR;
> > >    }
> > > 
> > > Or, if there are qlcnic devices that don't support FLR:
> > > 
> > >    if (dev->flags & QLCNIC_NEED_FLR) {
> > >      err = pci_reset_function(dev->pdev);
> > >      if (err) {
> > >        dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
> > >        return err;
> > >      }
> > >      dev->flags &= ~QLCNIC_NEED_FLR;
> > >    }
> > Thanks Bjorn,
> > 
> > that is very helpful.
> > 
> > I think that in order to move to option #1 some information would be needed
> > from those familiar with the device(s). As it is a more invasive change -
> > pci_reset_function -> pcie_flr.
> > 
> > So my feeling is that, in lieu of such feedback, option #2 is a good
> > improvement on the current code.
> > 
> > OTOH, this driver is 'Supported' as opposed to 'Maintained'.
> > So perhaps we can just use our best judgement and go for option #1.
> 
> So, it looks like option #2 is the safest choice as we do reset only if FLR
> is needed (when pci_reset_function() makes sense)
> 
> If all agree with that I'll re-send the path

Yes. Maybe wait 24h, and if there is no further feedback go ahead with that
plan?
