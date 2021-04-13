Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B33735E4D4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 19:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345750AbhDMRSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 13:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243246AbhDMRSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 13:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BFAB613B1;
        Tue, 13 Apr 2021 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618334308;
        bh=PsSIcGvOkAsoKkaAHl2VwpmarxSWakDBatYJ5vV6DdY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q4WQfv3lKwFhC02prZBLStdgbdwzOF2CoiXfCw+fvz6jKEOVjz5vj3KmfDY11r7Zv
         AtC6gbOIY1jBe8hQqi1THRHeG7sL3nwfbtHRGcasybK7UOZvnOG1ClXyrNufeIYy0U
         tLqfbSpxqv3j2gs2GF9kbCQ1go8m1RRfNxq7oACpOeAr5zlA+Bv/rKoMApE+P0jJ1u
         STMgjRDcK9jyCfewbRvhiG6hg0bTam7TVbW7z0uWALi8NS7i8U8ehzFQDs5/EPXy7K
         0uf4uXLYa157QpUh1AMA+zxCjCiZw5jc1Q6b3/Daw8+AHk24r12BTdc+Cq90llw4e3
         lBa1Av9sAjyRQ==
Date:   Tue, 13 Apr 2021 10:18:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net-next 1/2] net: hns3: PF add support for pushing link
 status to VFs
Message-ID: <20210413101826.103b25fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1618294621-41356-2-git-send-email-tanhuazhong@huawei.com>
References: <1618294621-41356-1-git-send-email-tanhuazhong@huawei.com>
        <1618294621-41356-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 14:17:00 +0800 Huazhong Tan wrote:
> +static void hclge_push_link_status(struct hclge_dev *hdev)
> +{
> +	struct hclge_vport *vport;
> +	int ret;
> +	u16 i;
> +
> +	for (i = 0; i < pci_num_vf(hdev->pdev); i++) {
> +		vport = &hdev->vport[i + HCLGE_VF_VPORT_START_NUM];
> +
> +		if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state) ||
> +		    vport->vf_info.link_state != IFLA_VF_LINK_STATE_AUTO)
> +			continue;
> +
> +		ret = hclge_push_vf_link_status(vport);
> +		if (ret) {
> +			dev_err(&hdev->pdev->dev,
> +				"failed to push link status to vf%u, ret = %d\n",
> +				i, ret);

Isn't this error printed twice? Here and...

> +}
> +
>  static void hclge_update_link_status(struct hclge_dev *hdev)
>  {
>  	struct hnae3_handle *rhandle = &hdev->vport[0].roce;

> @@ -3246,14 +3269,24 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
>  {
>  	struct hclge_vport *vport = hclge_get_vport(handle);
>  	struct hclge_dev *hdev = vport->back;
> +	int link_state_old;
> +	int ret;
>  
>  	vport = hclge_get_vf_vport(hdev, vf);
>  	if (!vport)
>  		return -EINVAL;
>  
> +	link_state_old = vport->vf_info.link_state;
>  	vport->vf_info.link_state = link_state;
>  
> -	return 0;
> +	ret = hclge_push_vf_link_status(vport);
> +	if (ret) {
> +		vport->vf_info.link_state = link_state_old;
> +		dev_err(&hdev->pdev->dev,
> +			"failed to push vf%d link status, ret = %d\n", vf, ret);
> +	}

... here?

Otherwise the patches LGTM.
