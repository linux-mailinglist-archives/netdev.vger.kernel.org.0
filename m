Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625E569FD9F
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjBVVTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjBVVTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:19:20 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2125.outbound.protection.outlook.com [40.107.243.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A78628228;
        Wed, 22 Feb 2023 13:19:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7XqG5+WgVJE/5ksVO2MWt6oAuxPswVe4PjWxzipZNtwHxxFrJRFLMTjrRYOdMtMw7uux5NNTmT+QVR7X5GK3ohXECpeJw0OyJIQqfEtYVF+UqvG62W2qLPppPMbgzikQ4yxt6P9quz/o2mPM+sYw0CtvfjBSTob5WW2YtjNq+bKoZQBgz1pEn1AdRpXtwOhuWhE3ZFkDoOSBUnPfwOx9giPYViPZw7LGaqmBLQjC4yoWRv26IJvJ/mFEobIc3KfIOn/bCPkN32oFMEBEg9VDcj7Yr43x26s7vZYkhyyzZ1KsMf/ZllsFJlnrGluEzuTd1yDj7yhjdxvVRK11mHyMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gEEZSntjA9nwey8iePbgPhER6BDcTSvklDDLsJXAmg=;
 b=ejCmauoaDM4ZfJdnzQi+vgLYxgWXHdVl3cOIPfUXUJeYItIKOXOWMAMQp2+SuzS3d2OwsufLBuwS2PfX0lapjldnqkC+BAm1NZWchqb/WChKvJCXPQdtIKDNW1zBO0yTjfu6AC6eItBzfBxroxph5cP6YwyVMi8sa24GWFDg9pl/jel5a703kgfqP8FROMB1KFJxLcKH0X/mO6uXmKn1iyQoBAjOPoIn8EipSVvyD9fZBAzDNOyYNWeiT68tWTlg0SpBt37UBnFA98Uqx+VpibcY1d30X+CdjEYDyFvfkG7xRy2SDG4kussujm/gE7PZvYo94jKxqYkLkv7Ycjpf9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gEEZSntjA9nwey8iePbgPhER6BDcTSvklDDLsJXAmg=;
 b=QCO+llikLFgRK2ieXVvdvZFXQnaNE0wultDeek99o0UrWnHLXqEfeALHJlGOuWuQB1faHqNTHjJzRhKbHO1qPcF8GNQ8YzfjqNj37WsyhIlJYkXMbLjVXQgWbnRf+zyMHrIQi15PO2+UdsA5XjuHWqNXjzNEbDNotydur91oLbU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5326.namprd13.prod.outlook.com (2603:10b6:806:209::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 21:19:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 21:19:16 +0000
Date:   Wed, 22 Feb 2023 22:19:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net] net: sunhme: Return an error when we are out of slots
Message-ID: <Y/aGzTGTaX7zumT8@corigine.com>
References: <20230222170935.1820939-1-seanga2@gmail.com>
 <Y/aCNSlx2p62iDYk@corigine.com>
 <ef539bfa-d9f7-5977-03f4-1fcf20c7ef65@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef539bfa-d9f7-5977-03f4-1fcf20c7ef65@gmail.com>
X-ClientProxiedBy: AS4P192CA0028.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5326:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a6d7a6b-536a-4f39-4fc8-08db151a73b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O2Do0hMgZ1mJLe7upInOPBVv4cnMqR2OzVfJ0WXzl3gEn6yYHn9mlzRq63tpIfzSZNKYKIU/W8TKcytWNkVyDPBt/CNRxd+pZNF//Dhp7UWhrYPk+JWJG0GDqMZTncsUgC20LvL4R9GTjmDoeiRBLY6OZX4izq0XTYg8x2mK+JL90ngm3UoMktKdWrrCoUrYHbGET3Boq7fphVq/O6wkaO/prMj+S9IoxgBCFKqj0jTl27l+gnv6lhRjYLgddtTi4hPYnfa7Y3ama2fVHYKi2TfcoLqiyz/AbbUXazFcbmwSaZ7eA6pT4c3AssNBPmEFBKxDyb42YAAogtINHTCMh23DmfyplW3hEO1i+fLp7VVuBYMtKdD2AqUGFnr5gsAI0MMPVhw+QfH2CLMxQMwhpCvYf5tU0256zFKKHnw6DZiEZLv0StTcyd9zf1iR4XNlKXwXArHwonlxVBayN0o63wkAhZXj1VCIrF0wN9b5nDaqQ1eCIeO14wuMowtD7oHFjt2kBQPXLMBbxL+WpSPlqUsIYEeL6MGEB73OW7/JHhEIBS1Pz7tmU6VbpbqZb0vXsCEO0YHkLEp+2FC9/bT/btKoDFFKzP2JZAAHWEu6LFdKnCA61dVMqC54uP4Ije84tGawbsn5Ok8fMayTuPbfRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(136003)(366004)(396003)(376002)(451199018)(86362001)(36756003)(6486002)(2906002)(53546011)(316002)(5660300002)(83380400001)(44832011)(38100700002)(8936002)(7416002)(41300700001)(6916009)(2616005)(478600001)(54906003)(4326008)(8676002)(66476007)(66946007)(66556008)(6666004)(186003)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p7sgcvqdfXzR46ILhOCwpPm//DGG02RTfEQFY7cfQNvyutHLY5T/vntTdK44?=
 =?us-ascii?Q?PPTcxbas4DSTeCQMCMOlXg/kWAZm0AP9r1bnOTkSRgxu1rVdQUSxvzVCUt13?=
 =?us-ascii?Q?wl7v8n7c+7YJY2gxeQxy7j+Hzq72touzdArZKLDJlbmc/IfhDzwJn3ryKqzu?=
 =?us-ascii?Q?+9ppnt9CAzo4ocx6KYLBG0hyyFz2rX56farHKYnlhuWphoq9CexgewvNLgA5?=
 =?us-ascii?Q?/B37y38qvRFjahBSbszDsP647skh88UcLpsYlRIySV7l4X8mdQ2JXtgfD3Nj?=
 =?us-ascii?Q?ATPVO6q5oS2MKyu3T/OJRK6MTl6udUg1eiMZ68J4MtQhW3/xdNBpMuQOqyvE?=
 =?us-ascii?Q?UDImozETFtroJATALTvcZ+e9QFUM/e7iVIEjAuxBJtSgQkGTL4lwKqq/D978?=
 =?us-ascii?Q?3w26GTvCrlzLVpwot8K3OZzE+ujHusP3AYoqU037fHrgEqh4IkdgaGD/yymI?=
 =?us-ascii?Q?w3ucecmzRWXnttJ0RVNt/fQW2q++d3a308SIIntgxhmarzn7JMuWSkd9Rzlv?=
 =?us-ascii?Q?380AUx6b/ak55q15XSgVwPxvzTMiSi4JIcRxFg1owCFVvR6Mrs9lWOg+e7Mc?=
 =?us-ascii?Q?ILUWVvyBLb+SBy+Xeq+Nkjeq5TUM+tiOfW/meH8mMekJNv/w3g5zpN6Chjah?=
 =?us-ascii?Q?dhlevEYlg/GC84Luyh1fkm25VlYuuIRA91VJ+RM+wyH72bwR0Q02jnrJ/2pi?=
 =?us-ascii?Q?IINS3ZHwGE9ZQjgq1Ywyc3P68R6vlwyAMqPuF5dbaj0OeOmdQCdiLDASxzmK?=
 =?us-ascii?Q?9Tt1X8/baOJ5qQYkvoVvwBnZTYH8pQB5q5kSayIPPyw1VQkp7xMTQTVM77Qm?=
 =?us-ascii?Q?d8zJr5MvAbiDE6jx3lAgvfT+RcRNE5f4L87Ex3hZ70nvBuHLJX1K46t3R6cT?=
 =?us-ascii?Q?v0EX9lOiNtWUQhgGYa7ip0VD91AcgFDY98wMqZ1h6/fjQ325krZMmDcqrK0M?=
 =?us-ascii?Q?1fozLadjh8V1quI5B+nNeZ0b6ieGkq9L6m5bcv9Y3LlbwEGrBsG/xZX/jASD?=
 =?us-ascii?Q?/IGFVSWydadcmJoVJz2mvJELTc3MwAtZuIB2SVcyNHPMvb3n3OgLoBytaRSU?=
 =?us-ascii?Q?7momq7YXPSi//eDJ9djq9uGuZXaEg0htFGbq+iR0usa+IixJ8n4y7z9rd3yi?=
 =?us-ascii?Q?tX27TTD6vzxgPDPwmoOEQhfmNwkp1zWknsFHP4ApAUoE1APm+jdLbwDrXMX4?=
 =?us-ascii?Q?1V9JFDIyRBCnGR1kc8+2NepbAB4kyeL5KSZGULTLgl0MCjOTaaGmaHm47fqv?=
 =?us-ascii?Q?Zv5dDhN9C9kdpgvG4O1y7QJiFy5CDsWmFv/usS4o/TyW34rNIyFahU6JKMc/?=
 =?us-ascii?Q?gAaeM4bQoRn3tFKJh2r0jkw5QVcpnYQEFcwq5z7saV4fJTZ6qTL6I0ei3c5M?=
 =?us-ascii?Q?jlZ8dyoN5IFdSFOgfRfY1epdSgJ+C16jkada9BoDRA9qC496zjBkATDT66TD?=
 =?us-ascii?Q?ErfJzBC6rCZj+TjhwvvrkK580PoboPHntqm5+cs22qLKYU8q3yBfceY55pnI?=
 =?us-ascii?Q?sLm+m2PyzZlIo7gOOWCNALwdZm2khGO0NLjh+Jgltge7y2K+XXM4TatC1kRk?=
 =?us-ascii?Q?Ae1HABnBAFP7B2qklBbA/0K5hpB/Sja/m0rSTRAcC9VowZfRXfgBF5vt1RlI?=
 =?us-ascii?Q?VcEnuqvoN8hFkFZL8HSBubMIsKioWt8tIpkisgVTPvoKJWFS3HM0zSqGMn7X?=
 =?us-ascii?Q?L9K8zw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6d7a6b-536a-4f39-4fc8-08db151a73b7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 21:19:16.0907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vfvzlNhwmUwr79x1W8bGAPDtvTIJ5TqBdMPQSaN5Lqb7PF+c3ewQPA5GVoE4rKvEE7M41kQo/X7dtkCHFNvxcsKyUsVGzTCFU0Pd0GwaYdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5326
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 04:07:15PM -0500, Sean Anderson wrote:
> On 2/22/23 15:59, Simon Horman wrote:
> > On Wed, Feb 22, 2023 at 12:09:35PM -0500, Sean Anderson wrote:
> > > We only allocate enough space for four devices when the parent is a QFE. If
> > > we couldn't find a spot (because five devices were created for whatever
> > > reason), we would not return an error from probe(). Return ENODEV, which
> > > was what we did before.
> > > 
> > > Fixes: 96c6e9faecf1 ("sunhme: forward the error code from pci_enable_device()")
> > 
> > I think the hash for that commit is acb3f35f920b.
> 
> Ah, sorry that's my local copy. The upstream commit is as you noted.
> 
> > 
> > However, I also think this problem was introduced by the first hunk of
> > 5b3dc6dda6b1 ("sunhme: Regularize probe errors").
> > 
> > Which is:
> > 
> > --- a/drivers/net/ethernet/sun/sunhme.c
> > +++ b/drivers/net/ethernet/sun/sunhme.c
> > @@ -2945,7 +2945,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
> >   	if (err)
> >   		goto err_out;
> >   	pci_set_master(pdev);
> > -	err = -ENODEV;
> >   	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
> >   		qp = quattro_pci_find(pdev);
> > 
> 
> Yes. That's the one I should have blamed.
> 
> > Which leads me to wonder if simpler fixes would be either:
> > 
> > 1) Reverting the hunk above
> > 2) Or, more in keeping with the rest of that patch,
> >     explicitly setting err before branching to err_out,
> >     as you your patch does, but without other logic changes.
> 
> >     Something like this (*compile tested only!*:
> > 
> > diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> > index 1c16548415cd..2409e7d6c29e 100644
> > --- a/drivers/net/ethernet/sun/sunhme.c
> > +++ b/drivers/net/ethernet/sun/sunhme.c
> > @@ -2863,8 +2863,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
> >   			if (!qp->happy_meals[qfe_slot])
> >   				break;
> > -		if (qfe_slot == 4)
> > +		if (qfe_slot == 4) {
> > +			err = -ENOMEM;
> >   			goto err_out;
> > +		}
> >   	}
> >   	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
> 
> That's of course simpler, but this also does some cleanup to make it more
> obvious what's going on.

Sure. I do think there is merit in a minimal change as a fix.
But I don't feel strongly about it.

> > Also, I am curious why happy_meal_pci_probe() doesn't just return instaed
> > of branching to err_out. As err_out only returns err.  I guess there is a
> > reason for it. But simply returning would probably simplify error handling.
> > (I'm not suggesting that approach for this fix.)
> 
> I think it's because there used to be cleanup in err_out. But you're right,
> we can just return directly and avoid a goto.

Makes sense, thanks.

> --Sean
> 
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Reported-by: Dan Carpenter <error27@gmail.com>
> > > Signed-off-by: Sean Anderson <seanga2@gmail.com>
> > > ---
> > > 
> > >   drivers/net/ethernet/sun/sunhme.c | 7 ++++---
> > >   1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> > > index 1c16548415cd..523e26653ec8 100644
> > > --- a/drivers/net/ethernet/sun/sunhme.c
> > > +++ b/drivers/net/ethernet/sun/sunhme.c
> > > @@ -2861,12 +2861,13 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
> > >   		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++)
> > >   			if (!qp->happy_meals[qfe_slot])
> > > -				break;
> > > +				goto found_slot;
> > > -		if (qfe_slot == 4)
> > > -			goto err_out;
> > > +		err = -ENODEV;
> > > +		goto err_out;
> > >   	}
> > > +found_slot:
> > >   	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
> > >   	if (!dev) {
> > >   		err = -ENOMEM;
> > > -- 
> > > 2.37.1
> > > 
> 
