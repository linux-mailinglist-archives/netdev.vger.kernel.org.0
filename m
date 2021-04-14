Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C7235F92A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352796AbhDNQmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231918AbhDNQmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 12:42:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6CB961153;
        Wed, 14 Apr 2021 16:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618418552;
        bh=keftbxasv+LlIBHJ83fZlJ3OQDTLXDcZSWTeakEM8yo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DdbQ4zESblVTy3KSkLAZZ04Rfrd0kM5/yME0fqdrSzrAK1JWX549KX+QJeTKIPHH/
         5gux+Rp/EJ9nMzohJ7FqQngzwMHxFhg4ZSjpDhJoAOVpGzkCN6GM43637QYqyzzwSA
         H325mRbo/Vx0Mp6t8BGSwWgsZ5UKHAUPecX1JZ45QNSh2OSq5TWg1bzL+bzCH2guY9
         auzy3SlTXicak58rrWA8bztDOwj31p2arzPBmWyv+btj7VUTIxuGxUPLxs3UgJePAk
         moFPwRsYF2ZazjWrzRsXfL6AbVCH1tKNDXIVD4ux2J9dK+ncRrMUEpCA1Tg9ghdVch
         uTURUBlbypu6g==
Date:   Wed, 14 Apr 2021 09:42:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net-next 1/2] net: hns3: PF add support for pushing link
 status to VFs
Message-ID: <20210414094230.64caf43e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2dac0fe0-cdcb-a3c5-0c72-7873857824fd@huawei.com>
References: <1618294621-41356-1-git-send-email-tanhuazhong@huawei.com>
        <1618294621-41356-2-git-send-email-tanhuazhong@huawei.com>
        <20210413101826.103b25fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2dac0fe0-cdcb-a3c5-0c72-7873857824fd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 09:51:38 +0800 Huazhong Tan wrote:
> On 2021/4/14 1:18, Jakub Kicinski wrote:
> > On Tue, 13 Apr 2021 14:17:00 +0800 Huazhong Tan wrote:  
> >> +static void hclge_push_link_status(struct hclge_dev *hdev)
> >> +{
> >> +	struct hclge_vport *vport;
> >> +	int ret;
> >> +	u16 i;
> >> +
> >> +	for (i = 0; i < pci_num_vf(hdev->pdev); i++) {
> >> +		vport = &hdev->vport[i + HCLGE_VF_VPORT_START_NUM];
> >> +
> >> +		if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state) ||
> >> +		    vport->vf_info.link_state != IFLA_VF_LINK_STATE_AUTO)
> >> +			continue;
> >> +
> >> +		ret = hclge_push_vf_link_status(vport);
> >> +		if (ret) {
> >> +			dev_err(&hdev->pdev->dev,
> >> +				"failed to push link status to vf%u, ret = %d\n",
> >> +				i, ret);  
> > Isn't this error printed twice? Here and...  
> 
> They are in different contexts. here will be called to
> update the link status of all VFs when the underlying
> link status is changed, while the below one is called
> when the admin set up the specific VF link status.

I see.
