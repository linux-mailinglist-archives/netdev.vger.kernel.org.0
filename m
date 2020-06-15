Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1E61F92E5
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 11:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgFOJKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 05:10:19 -0400
Received: from mail-eopbgr130104.outbound.protection.outlook.com ([40.107.13.104]:57216
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729148AbgFOJKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 05:10:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcwehTnhNdjkCLF4P7dYR00zxbq80vr+Fq1fhcGgd9/YUiahSheR4GoAud2r++rswwH3QqADDbNiyXARBCEIVcgpM1emQxBjce8j5tlsB4HiW7o9MUpO9NY+QeufbwkbiUOm4xyambyEeMJ0Fe/kWDbXSh/tlglBu2O5XFQOn7srDe3dmcgfzZgn7frWz/1lhK1VMeaTTDTSYtRiPMbp0lBuNFnJd3LNQuUZi8jaIOKWhUlyin/b1t2sZ05EpTPlQvvcP2j0YNxCKUEoYuzv8V397tkS++DZLt2wEsyXbTe54EHKEE/pmFIm+a4Ps8aL2BIi+9/OlAC4SrpRsarumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/CfZNXQqlQhTv2itVY86/TmE56WpcXzgWR4pYV+gVc=;
 b=Ji3+iv3aJuT+JQ9KCtECtVXEb1jOQMWwlX49oEAzC5JABYfLbDfKVEiTUOMu+6H0+kSGugJ9pFfpVAEyn/v86pWTmKpdg16RRze0gKgOo2Mp2TVDiX06hQpGNyYjAMZ5OWhrggJqUVcA9VQjze5bb0fm2y7CzpY3G0dHncWDQZti5WlfsKlWyHcRU87JtVNc2zVpx+ARSaIvWiK2rYTK0MxwO3SwkAYpG8W2KsODstFACTmv0uPTh6uC/r8zMfaX7fRCD8n83h8DNA47MMRyn4yd0MmgvD9+Wps2v/oO7h8fZ87g8MphhzGAu+uZfqG+92xMXSHQR2+L6qulQxgQfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/CfZNXQqlQhTv2itVY86/TmE56WpcXzgWR4pYV+gVc=;
 b=lN0pUg5tMI+hX6VtpQ3umOmA6sa/DETVL2wxRpOuChGzcP8OnT5Fxd6qLEOvzmXO/HjkOHANmug+5P6NXwgnJobQDH9749f1UNBDvezesDSbsXoyLhI/7JB9paHqqng+5omKkJwsTssYMgz9WOtBNfDqMTuM9vPF48rMWuiC4JU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR0501MB2337.eurprd05.prod.outlook.com
 (2603:10a6:200:53::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Mon, 15 Jun
 2020 09:10:15 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3088.029; Mon, 15 Jun
 2020 09:10:15 +0000
Date:   Mon, 15 Jun 2020 11:10:14 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        lorenzo@kernel.org
Subject: Re: [PATCH 1/1] mvneta: fix prefetch location
Message-ID: <20200615091014.kj2avcjyme7jecou@SvensMacbookPro.hq.voleatech.com>
References: <20200614071128.4ezfcyhjesot4vvr@SvensMacBookAir.sven.lan>
 <20200614102343.47837452@carbon>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200614102343.47837452@carbon>
X-ClientProxiedBy: FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20)
 To AM4PR0501MB2785.eurprd05.prod.outlook.com (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21 via Frontend Transport; Mon, 15 Jun 2020 09:10:14 +0000
X-Originating-IP: [37.24.174.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 148272c2-5faa-4aad-0bee-08d8110bea83
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2337:
X-Microsoft-Antispam-PRVS: <AM4PR0501MB233783A5E896E188EC23E87CEF9C0@AM4PR0501MB2337.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 04359FAD81
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGO7duO9JaOmVx9ABRrhRBwMaW2xbJcaytqDSaABvuRv8oWYHhqtBF0rCtc1b0C1lNYwHkai1VE/AYMaxA39szlBeqFahobxU1QoadK17iQPQA+JJopu4SoJIW5bFtDm8r7MhMuE/ahvhHKcp38zUy0LRM4rSwrI+b40HvnGW2Bhve8kn/oz+qANwScsv+SuJQEGo2mxZUHD5EKcplrmaiPVyp9TxivlWVXHly+QlwxVfefGNjDBepqwprcU13g8id2hd30yQvnsQxE2YdpR1QHSx2aPW0EeC+WzPrXWtB98HbvA3iRJ2cKRFxdCQIRaeDkwF/2xZ1qAh6V0oZ9VomW7clEbK6tTX8H9idSE/g9mCvf7s3ReSmthHQxoqrS8nsAj2vH54RnTOIO+JCwfPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(39830400003)(136003)(966005)(86362001)(5660300002)(83380400001)(508600001)(66556008)(6916009)(6506007)(66476007)(8936002)(7696005)(52116002)(66946007)(956004)(316002)(44832011)(186003)(26005)(1076003)(9686003)(16526019)(4326008)(2906002)(55016002)(8676002)(45080400002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2NYurmjqRDNiSXUS/tchAAuatQqvVqKw0kVRVNFQr9y188iPKeX8czfNVGBK+TLpYiOw7dMjv2QUFrw8/6CTKWqN0OkHpq2GsYCxhE3gKVYQJ+Xd/zVCiZy+Qs74bknWyty7EB0WTGMHf9G11Qw5c+4D0mG2nkFU0dc4RJxm/I5sPWI7xMczCcD7L+GkguI2N/whCvas6Uj7rxNn8i8NHZm9fYptq2o3+YPVFqK1J4Oy4DpMuEgjOx+BRjQJjenAxOVmJnwgMueFoU0EK9L2VNswMxWDrIIEo0uqaFWawHdRoHscY+DTARvswJ70l86aOApWOBM0D68D8SwvQ7GMYstJXc/bL+ePjoZ4QekH72b8Pkhy0rdbyR+kAnEeytb37ScQg4VBWGGLS04Iw4JSVVZGS6aYoUqYlcNuCvKpg3BroIp7v4dwukwrky+WkIu7I4yhrLBiIj5yX9cOKdwLPbsN2TKJ8dYVlicO3IkmnnQ=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 148272c2-5faa-4aad-0bee-08d8110bea83
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2020 09:10:15.1573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eivjwaXJuSKtSc5P09F6AsvBNHoLWufpMCJ4gdmNeAKPil5RR2nodCwaxT+gBK3etvFYQz3JK7hrHxBF/MDW+LgKR25mNvodTJDvmYVO3sI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2337
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 10:23:43AM +0200, Jesper Dangaard Brouer wrote:
> On Sun, 14 Jun 2020 09:11:28 +0200
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> 
> > The packet header prefetch is at an offset
> > now. Correct the prefetch address.
> > 
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 51889770958d..344fc5f649b4 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2229,7 +2229,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  				len, dma_dir);
> >  
> >  	/* Prefetch header */
> > -	prefetch(data);
> > +	prefetch(data + pp->rx_offset_correction + MVNETA_MH_SIZE);
> 
> The comment does say "header", so I guess your change is correct if we
> are talking about the packet header.
> 
> Currently this prefetch will help XDP-redirect, as it store xdp_frame
> in this area.
> 
> >  	xdp->data_hard_start = data;
> >  	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> 
> If you really need to prefetch the packet headers, it would be the same
> as calling prefetch(xdp->data), right?

Yes, that is correct.

> 
> Have you benchmarked that this prefetch is a benefit?

I just ran some forwarding tests and the difference is not measureable
in normal forwarding.
You are correct XDP Forwarding seems to be 1-2% slower.

I guess you can disregard the patch.

> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: https://eur03.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.linkedin.com%2Fin%2Fbrouer&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C4f3ae28c82514407dfd508d8103c4d1b%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637277198467217085&amp;sdata=qIJ3tkU2mHFqZpArOGnQWSPEVtTBMXK8MpekSGcKavw%3D&amp;reserved=0
> 
