Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888866D901E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbjDFHGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbjDFHFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:05:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::70a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E8BAD37;
        Thu,  6 Apr 2023 00:04:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7uYXX5AX9w9wlQw5WgslYlCO4yQejZpgqQjzaA6PGnlWSiu9hAUG7hiuvpCGV9kre50pFa9kwMzUNltn3UB+v9b+4NR+HX2OPWqZlO6Vw6Vr2XQvdRHV7Ik05s4tir11HL1bJ6YXDbTYoLXAdcqKQ6Ke0m7oqsy9uBQU2O7zDNNR2WKoXrAb60ts7SYAlJtokovgffr84wQ/yQaW85DbrbojBfFhp/HcINz9qkjHgaVamTz1euBXuYNbnti9T0cZfI0Q5rJ1Ry/gCgXHkY/yY07aOHxdPhSDVjH0UiamEagxCq02MSKZvtyZx0bZH2xTeTmJ41q18ux1CQxfIdcmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9rNZljf5puaMyPbm93C6vAJbb/8q/ZMu3NYp0bykEc=;
 b=ipUsqkn27/ipPwppa3DLfktHe6GfsizkmAqCkjk2tzUtBnz2tq5WQxOxMI68bDRmCQBJEBGzR5k+dTEf+XJnByoAhk8E7HEKrnU86Qc84PNMO8T8TjbO6pifI5GZAn90/H4MwigW0/3yjoj//ksrzxw+OofiFMlbbtsWfEpPM+rmTCEuT6ysDIPAkhlaqcMaAsmCKgK0bbZ+w/ikwbGXMbmQVej4liU0sI7nli9erBlBjX0Z1932WJaZl4ksHJjBUr1KKfFilNkmoEkwncT2fL+5NPj7KmZvhH2tKUaIoPQsj/aYVuIPUn/+eKNeqeAGklBfjMzOUi0cRyPFs9Ui6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9rNZljf5puaMyPbm93C6vAJbb/8q/ZMu3NYp0bykEc=;
 b=RHLGyWsMcad5vglTs1qhTaMX6uM/3VwEpVQ3xG+CyTWLsnINkHuH+bbifHvAo5/zTHX6Cp4gRLCbd81uXwxyZyCmF+aFWdgN1K/23Zc9IInN36SH1yFoIOq1HqI3RgwfvlZIycoShZP8ouQ8rS6nAxwm/+teNjbnYXRsJy59PLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5530.namprd13.prod.outlook.com (2603:10b6:303:182::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Thu, 6 Apr
 2023 07:03:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 07:03:43 +0000
Date:   Thu, 6 Apr 2023 09:03:36 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Denis Plotnikov <den-plotnikov@yandex-team.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] qlcnic: check pci_reset_function result
Message-ID: <ZC5uyOt7mevNyS6f@corigine.com>
References: <ZC1x57v1JdUyK7aG@corigine.com>
 <20230405193708.GA3632282@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405193708.GA3632282@bhelgaas>
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5530:EE_
X-MS-Office365-Filtering-Correlation-Id: 79a50dda-1b5c-4e11-41e1-08db366d0ebd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HW1/mMxtPYMklS5ovpKgxghCirAR7/nadtvZPHwDIJ2q9B1JcKwbN21bDRSbvxJPLiKipaqHWMkJB7BSt5ePnUnzfsyucSLkel77QHNThLPYM4GolQucTZwMIv4wW21fjfv0+Xg3K3JnrrIunxW+yh7mr7OQmaFzc3Fpnm4HxzP7JlErxT6IK5U0XtfTnfv8BCVfcWZv+qM3OXnHV4Vc7pLwsgIKGDquNHgaR/7/a7P3evt1Co2M6ytp4fESuuwAW+3PAHE2SdE2QmBRTDssY7fvmZbhKLB+uIQQGk91+aMEeIt+nyGo1eeRvCZypdDt+bJ9ucRn3xW/EvMSvLnOYV9nx0TgyyF3mR+Zq+uboYw5kLd+wGsEni2eoBXsqrtxdm3jGm2crvqeOico4B5t5luxHR29ejDJmwU8IdSVm9W65Loj9Yt5Y48YnfLR7f7nvgP8WQeUxIZMU302cX+z5vPM08UCZZWdK9iO7AXJZ0+aSbRqRzxxa52SOuuJKbCSxydTGUCmuXBfPakujdQSRBYnHBADweGg5kI9+Wl/HxV9ARFU8Gavj2Cw3f+3jlSH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(346002)(376002)(39840400004)(451199021)(44832011)(8676002)(6512007)(36756003)(38100700002)(66946007)(6916009)(6486002)(316002)(6666004)(66476007)(4326008)(54906003)(66556008)(5660300002)(41300700001)(53546011)(478600001)(7416002)(86362001)(2906002)(8936002)(2616005)(6506007)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X16NJs6Q07s1pGnfKkouSc2obLz2mavQ54ff4p+VY1+rGofKZX+TA44MOT1N?=
 =?us-ascii?Q?hg+QTQypBU3lVU+kOKTxtEamdreCGW9zvV4GeR8S4KY4HPDMG/0NN8RYoEdY?=
 =?us-ascii?Q?Kytiz4Tuq0Xw5kGfD7L4Z+Jkbc5GqPc/2QR4zm4GLghnMkS8+Ryu9sSQ65kV?=
 =?us-ascii?Q?FVRrXIPZv7kj2cMZ4mnuNGUngXdJ3uCDsTeWB+yvxVv1Gw+Bs1Xtw0pLJs/U?=
 =?us-ascii?Q?PE5DaZHG3uUU8ua2ZGtey5SWxwkGzOv4R50HtDbDtd5rzrUIJig7RzbsSKq7?=
 =?us-ascii?Q?3rqSryYkcKgMXlwDf6Cfl2mO8GJZSo5GdDW36n09y1Ra3ZzdER1QD5S9zAde?=
 =?us-ascii?Q?gsjCOynQn04YpjLzkR0/awJswwSrSm4qwV70unfOCxfKCehF6HB5vk7mTjwR?=
 =?us-ascii?Q?uK+aXUxDvns0h6dvJfaE+kVbLGejNBabx+4t8F2NpqIkm29I3NKRa9gO+Za8?=
 =?us-ascii?Q?2KoQPnzPP9kcT2RaulW2G04hOMj7qgVTIqJH0sSA8nhqDIMc69W/8iT3w98l?=
 =?us-ascii?Q?m9Uiio/hFT/EQ7hJJmY5I/YLAMEkP+90PMWj3sBs2yYS3PIDJkQo5y5Mq4ur?=
 =?us-ascii?Q?XKXAXAVZhXowMwOwCdv0SEsIwGXs6Tt17W9Uj7LRS/fnSTOfLJ5zvxyj8CFg?=
 =?us-ascii?Q?D4gz85iHhWbPnNPjXU6v1racST5azTSW7HfceuGvIoUawYhjmhOqgP2ANuUu?=
 =?us-ascii?Q?4B0G0TQWpXx/zR9tSgvSd0lawmQVGvNiOxk8l1KUn5YFQmcQx4o8WUtO+hny?=
 =?us-ascii?Q?/b9BEpc5SwbD22kzduYbiqtfcxkAF5inYgtE60wWvFZmDeB+nGolzGmSzDxq?=
 =?us-ascii?Q?zrbJm2bVakFSYzMcGCkoV94JULMk+JAfRoMO51sTEK4pCG0dOk/fE1J76cLq?=
 =?us-ascii?Q?3FNOkD3xmrXs0sRMekHytHsEP3zg/RtjOICP5G2G3YdHxsFkwYK9zH5TLwVd?=
 =?us-ascii?Q?NBghosSISezBkgm8y41QmRKfVypJMMsvzRrM/aVULp+J4/XWoqY+Bgv0sLrt?=
 =?us-ascii?Q?jgWrU1ul9igQ2X0T8F1AFH7s+sblYCLXqsTcdiniSDZz2EAz8ZoDHlosZUpt?=
 =?us-ascii?Q?O5MzwrCXJZ+OVRJczi0Pm75KfMBKE5qtFxHWdJrbR8RpVpzk8kZ2YVWTkKSK?=
 =?us-ascii?Q?kbDLuiEkmyi1OuR/c3y5Sj6HqFarRbRaxLFMkJveL/sRPCT/xpaZOM4miLqN?=
 =?us-ascii?Q?lOEZtxhd88B9bjA5Szb+jntoHT1O2smdOumpEXePHSu4kGUBHhaNuaqvUgDQ?=
 =?us-ascii?Q?m5VTEn6ZXMw5bwjXlF0eergOS5agTeNkIGAGeyCKRUBKMXphaDNOovzFjL9j?=
 =?us-ascii?Q?NVknRiuvqwrzF89qBoNgntEZm3VmKl0kKPSgD38MWHQBxqvB/mKyc2EvRm/j?=
 =?us-ascii?Q?EH2Fk8eatOrNKfa9H2MlQy0Gkd6zusbekdiv+Lj+watg6pMEks5yadx2r2W1?=
 =?us-ascii?Q?tVfPJrOPtbvd06qJLI5jy/ji9Kb2aggAEuecHOvwV0rHKA01pzyvLy4brxD/?=
 =?us-ascii?Q?by0YvWOOcMm7Y9OS2CXhVxX0imeOctzhN+tGJBolY7arshI9E3p2u+LgaU7E?=
 =?us-ascii?Q?mw8fG56VJ350ljiR8FeVFaCu8KWIHnVNxW0J3n2/EYwGTP0qWJWQFw9uNNo3?=
 =?us-ascii?Q?MFXNt21ivC0afutDUTV+n5sJxoKZWlfQdkXDIoSPaK3P0ZbQ/PdaW38VZrkh?=
 =?us-ascii?Q?lb9tCg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a50dda-1b5c-4e11-41e1-08db366d0ebd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:03:43.2721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2gSf2fpQ+efm1ZD+bx7bdVKe2wkYZpYGf4v3g3BLFJtuREqrClqdvAYoBeN8A8ZxohkGp7ef5NJcT6LG8UBzLNaG+j98/qGJ6OxJUF9U2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5530
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 02:37:08PM -0500, Bjorn Helgaas wrote:
> On Wed, Apr 05, 2023 at 03:04:39PM +0200, Simon Horman wrote:
> > On Mon, Apr 03, 2023 at 01:58:49PM +0300, Denis Plotnikov wrote:
> > > On 31.03.2023 20:52, Simon Horman wrote:
> > > > On Fri, Mar 31, 2023 at 11:06:05AM +0300, Denis Plotnikov wrote:
> > > > > Static code analyzer complains to unchecked return value.
> > > > > It seems that pci_reset_function return something meaningful
> > > > > only if "reset_methods" is set.
> > > > > Even if reset_methods isn't used check the return value to avoid
> > > > > possible bugs leading to undefined behavior in the future.
> > > > > 
> > > > > Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> > > > nit: The tree this patch is targeted at should be designated, probably
> > > >       net-next, so the '[PATCH net-next]' in the subject.
> > > > 
> > > > > ---
> > > > >   drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
> > > > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > index 87f76bac2e463..39ecfc1a1dbd0 100644
> > > > > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > > @@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
> > > > >   	int i, err, ring;
> > > > >   	if (dev->flags & QLCNIC_NEED_FLR) {
> > > > > -		pci_reset_function(dev->pdev);
> > > > > +		err = pci_reset_function(dev->pdev);
> > > > > +		if (err && err != -ENOTTY)
> > > > Are you sure about the -ENOTTY part?
> > > > 
> > > > It seems odd to me that an FLR would be required but reset is not supported.
> > > No, I'm not sure. My logic is: if the reset method isn't set than
> > > pci_reset_function() returns -ENOTTY so treat that result as ok.
> > > pci_reset_function may return something different than -ENOTTY only if
> > > pci_reset_fn_methods[m].reset_fn is set.
> > 
> > I see your reasoning: -ENOTTY means nothing happened, and probably that is ok.
> > I think my main question is if that can ever happen.
> > If that is unknown, then I think this conservative approach makes sense.
> 
> The commit log mentions "reset_methods", which I don't think is really
> relevant here because reset_methods is an internal implementation
> detail.  The point is that pci_reset_function() returns 0 if it was
> successful and a negative value if it failed.
> 
> If the driver thinks the device needs to be reset, ignoring any
> negative return value seems like a mistake because the device was not
> reset.
> 
> If the reset is required for a firmware update to take effect, maybe a
> diagnostic would be helpful if it fails, e.g., the other "Adapter
> initialization failed.  Please reboot" messages.
> 
> "QLCNIC_NEED_FLR" suggests that the driver expects an FLR (as opposed
> to other kinds of reset).  If the driver knows that all qlcnic devices
> support FLR, it could use pcie_flr() directly.
> 
> pci_reset_function() does have the possibility that the reset works on
> some devices but not all.  Secondary Bus Reset fails if there are
> other functions on the same bus, e.g., a multi-function device.  And
> there's some value in doing the reset the same way in all cases.
> 
> So I would suggest something like:
> 
>   if (dev->flags & QLCNIC_NEED_FLR) {
>     err = pcie_flr(dev->pdev);
>     if (err) {
>       dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
>       return err;
>     }
>     dev->flags &= ~QLCNIC_NEED_FLR;
>   }
> 
> Or, if there are qlcnic devices that don't support FLR:
> 
>   if (dev->flags & QLCNIC_NEED_FLR) {
>     err = pci_reset_function(dev->pdev);
>     if (err) {
>       dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
>       return err;
>     }
>     dev->flags &= ~QLCNIC_NEED_FLR;
>   }

Thanks Bjorn,

that is very helpful.

I think that in order to move to option #1 some information would be needed
from those familiar with the device(s). As it is a more invasive change -
pci_reset_function -> pcie_flr.

So my feeling is that, in lieu of such feedback, option #2 is a good
improvement on the current code.

OTOH, this driver is 'Supported' as opposed to 'Maintained'.
So perhaps we can just use our best judgement and go for option #1.
