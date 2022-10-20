Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94B860617E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiJTNXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiJTNXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:23:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B773319A235
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 06:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A972FB8267E
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 13:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC5CC433D6;
        Thu, 20 Oct 2022 13:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666272187;
        bh=Ct2DQ0YC8p5BJq4h/X7oPFNuhFPuuIJdWtTvC6wLIE8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SQkI+jkv0G+7PwY77U4M2cgl57u8xHmvSbYY3CG+UPnwmYQnM868T18/S6shHt/eH
         CzmVEd81rxHpByWiO39N+0b0qPrp+5W5zAVthrpxs2qbNoDKp/KRni1LK2jW2ar6Ee
         IV4rwBskql/f3nlEo6OinASfGPz6n0eW3r4mPwNI+jBeE0b80zUpDSHVyA+hqS+PXD
         Az6XYq6eLO+NwOIfV4Ee6MMfb1M+y7iJw3cmvSZqGzrV/9K0PK2ZkizvFIcvJu/EKy
         MTYSLcoKTSiHW6qGjlerr0FOy55T0jxmUtN1eHl3HW0kJrbUPIKuhCd24gJIdIZnem
         NE/N7rrGOB/EQ==
Message-ID: <8589e829-9331-b2bc-4f27-d224716ed120@kernel.org>
Date:   Thu, 20 Oct 2022 07:23:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH iproute2] dcb: unblock mnl_socket_recvfrom if not message
 received
Content-Language: en-US
To:     Hao Lan <lanhao@huawei.com>, lipeng321@huawei.com,
        shenjian15@huawei.com, huangguangbin2@huawei.com,
        chenjunxin1@huawei.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, Petr Machata <me@pmachata.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
References: <20221019012008.11322-1-lanhao@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221019012008.11322-1-lanhao@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc Petr ]

always add authors of patches you are fixing.

On 10/18/22 7:20 PM, Hao Lan wrote:
> From: Junxin Chen <chenjunxin1@huawei.com>
> 
> Currently, the dcb command sinks to the kernel through the netlink
> to obtain information. However, if the kernel fails to obtain infor-
> mation or is not processed, the dcb command is suspended.
> 
> For example, if we don't implement dcbnl_ops->ieee_getpfc in the
> kernel, the command "dcb pfc show dev eth1" will be stuck and subsequent
> commands cannot be executed.
> 
> This patch adds the NLM_F_ACK flag to the netlink in mnlu_msg_prepare
> to ensure that the kernel responds to user requests.
> 
> After the problem is solved, the execution result is as follows:
> $ dcb pfc show dev eth1
> Attribute not found: Success
> 
> Fixes: 67033d1c1c ("Add skeleton of a new tool, dcb")
> Signed-off-by: Junxin Chen <chenjunxin1@huawei.com>
> ---
>  dcb/dcb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/dcb/dcb.c b/dcb/dcb.c
> index 8d75ab0a..a6f457fb 100644
> --- a/dcb/dcb.c
> +++ b/dcb/dcb.c
> @@ -156,7 +156,7 @@ static struct nlmsghdr *dcb_prepare(struct dcb *dcb, const char *dev,
>  	};
>  	struct nlmsghdr *nlh;
>  
> -	nlh = mnlu_msg_prepare(dcb->buf, nlmsg_type, NLM_F_REQUEST, &dcbm, sizeof(dcbm));
> +	nlh = mnlu_msg_prepare(dcb->buf, nlmsg_type, NLM_F_REQUEST | NLM_F_ACK, &dcbm, sizeof(dcbm));
>  	mnl_attr_put_strz(nlh, DCB_ATTR_IFNAME, dev);
>  	return nlh;
>  }

