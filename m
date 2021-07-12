Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D12F3C60AB
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbhGLQgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 12:36:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51772 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233444AbhGLQgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 12:36:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CGU89e029214;
        Mon, 12 Jul 2021 09:33:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=VLN6wgsPJ7jmjrlj1px8ofQio/utybjFuvJqyGS8OEM=;
 b=F+n6w9QQv3TwPM3pCDxYWDO9DL0BRIN3TE4ZkEeW1sjmW3U5mCre1HFi04sqIQbP03So
 6+xtyVCP9FbrRzM5DJACgVCV5j4HaGdCK4oZSntfup0oZ76ZMXYXqsWWw60Wx2W0BvXi
 /HlkVWJCtkryVG78FNicbYbqQJSFAxJ3WW/NjibznXpgZUUZ+vvaf0LgZ7hrCRMdLmMO
 PczZsi2AvSlcdDKbfGCzoY94juDeiRk+ceFKLjgdr/7526Eg5z3dIzZ5NhKR5M8a3qRV
 kATguOF6PJaAvQ8LBmyX+2BWmSttOAzM25raMBGZP621j8WL5vSDzgKUPpbjUjAm45wb kQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 39r9hjkcpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 09:33:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 12 Jul
 2021 09:33:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 12 Jul 2021 09:33:40 -0700
Received: from [10.193.32.64] (unknown [10.193.32.64])
        by maili.marvell.com (Postfix) with ESMTP id 34B833F7060;
        Mon, 12 Jul 2021 09:33:38 -0700 (PDT)
Message-ID: <6ded0985-7707-4bde-adb2-ee1f411055d7@marvell.com>
Date:   Mon, 12 Jul 2021 18:33:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:90.0) Gecko/20100101
 Thunderbird/90.0
Subject: Re: [EXT] [PATCH] [net][atlantic] Fix buff_ring OOB in
 aq_ring_rx_clean
Content-Language: en-US
To:     Zekun Shen <bruceshenzk@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <YOtc3GEEVonOb1lf@Zekuns-MBP-16.fios-router.home>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <YOtc3GEEVonOb1lf@Zekuns-MBP-16.fios-router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 30nYdCJipHEu6cMxPJWx_JWoX8W7zyOt
X-Proofpoint-ORIG-GUID: 30nYdCJipHEu6cMxPJWx_JWoX8W7zyOt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_09:2021-07-12,2021-07-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zekun,

Thanks for looking into that.

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> index 24122ccda614..f915b4885831 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> @@ -365,6 +365,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
>  		if (!buff->is_eop) {
>  			buff_ = buff;
>  			do {
> +				if (buff_->next >= self->size) {
> +					err = -EIO;
> +					goto err_exit;
> +				}
>  				next_ = buff_->next,
>  				buff_ = &self->buff_ring[next_];
>  				is_rsc_completed =
> 

From code analysis, the only way how ->next could be overflowed - is a
hardware malfunction/data corruption.

Software driver logic can't lead to that field overflow.
I'm not sure how fuzzing can lead to that result.. Do you have any details?

Even if it can, then we should also do a similar check in `if (buff->is_eop)` case below,
since it also uses similar sequence to run through `next` pointers.

Thanks,
  Igor
