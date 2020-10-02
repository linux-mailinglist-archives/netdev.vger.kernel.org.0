Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461F128156F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388153AbgJBOmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:42:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10008 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgJBOmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:42:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092Ef8lY018083;
        Fri, 2 Oct 2020 07:41:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=u/soKV2GBHhJ6G6bsTAHHXnIGmixGVhtcYL4FN1tdW0=;
 b=ZmjytmGDkvyRbr5V/QDJy9xgNRxmP7FZ8j9idu5FDwVoGlWebmUptBih4ZAnyAPVMzIj
 eS5ObEfFZGjY1A2lxEEzZCa/IZjWUkboWE+VAcxi7h7b4skE+Z89TJQ+gW06Pm0/gtfd
 QDO036S+ip+bseiVMSZzn4+pKMzWC0uNbLS8xy8FoIaOHkYYCTi+4pUBAgAJTGu7xW1U
 zT5+cxGTpqyaCUDWZdHpDq6CnKufMOE725peufCucmOLjUzntf0tQ0cn3k3YRixLdSny
 KEsvD1Wg49+qW7I3EPBjPMBwYR8ML9I5Osn/VfZKXbFGNv0UO0KCjUIzXkds5coNtK4b Ww== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33wjds39ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 07:41:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 2 Oct
 2020 07:41:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 2 Oct 2020 07:41:55 -0700
Received: from [10.193.39.7] (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id 0C6853F703F;
        Fri,  2 Oct 2020 07:41:53 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v2 net-next 3/3] net: atlantic: implement media
 detect feature via phy tunables
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201002133923.1677-1-irusskikh@marvell.com>
 <20201002133923.1677-4-irusskikh@marvell.com>
 <20201002142452.GD3996795@lunn.ch>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <28e7c215-d1f9-77dd-a0bb-3acff2841bf1@marvell.com>
Date:   Fri, 2 Oct 2020 17:41:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101
 Thunderbird/82.0
MIME-Version: 1.0
In-Reply-To: <20201002142452.GD3996795@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>> +	if (val > 0 && val != AQ_HW_MEDIA_DETECT_CNT) {
>> +		netdev_err(self->ndev, "EDPD on this device could have
> only fixed value of %d\n",
>> +			   AQ_HW_MEDIA_DETECT_CNT);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* msecs plays no role - configuration is always fixed in PHY */
>> +	cfg->is_media_detect = val ? 1 : 0;
>> +
>> +	mutex_lock(&self->fwreq_mutex);
>> +	err = self->aq_fw_ops->set_media_detect(self->aq_hw,
> cfg->is_media_detect);
>> +	mutex_unlock(&self->fwreq_mutex);
>> +
>> +	return err;
>> +}
> 
>> +static int aq_fw2x_set_media_detect(struct aq_hw_s *self, bool on)
>> +{
>> +	u32 enable;
>> +	u32 offset;
>> +
>> +	if (self->fw_ver_actual < HW_ATL_FW_VER_MEDIA_CONTROL)
>> +		return -EOPNOTSUPP;
> 
> So if the firmware is tool old, you return -EOPNOTSUPP. But it appears
> cfg->is_media_detect has already been changed?

Hmm, right. The problem here will be that next --get edpd will return "enabled".

This'll also happen if by some reason FW command will fail to enable EDPD.

Think I have to save 'is_media_detect' only after successful FW operation.

Will send v3, thanks, good catch.

Regards,
  Igor
