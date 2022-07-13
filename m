Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31768572A9D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiGMBJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiGMBJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:09:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E240C9100;
        Tue, 12 Jul 2022 18:09:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC017618CA;
        Wed, 13 Jul 2022 01:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12C5C3411E;
        Wed, 13 Jul 2022 01:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657674556;
        bh=VmntzbmKZNafnsvnBrCuHRRxUYzJnrYmUnQpuOsb25c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=flhpv2LdQeVnrTmtUCCwfApQkLHolqYRJRldzyCy3iflwjtwG3OsmK3ElrktCKc/N
         Dtk6frRurVe1SRfPMwQyBHMEfUCutZZNBu3pk+sGXKvi3kHYAVT15NPwx7sT6+r3AK
         s7Sdml5NrAU6echUu5aUd3NiHeb2Rf6RzroS4nMBOVCdAlOL9ouUXcrdr5XSpdAOR7
         OABef5AYx/axL45gRGlb49CwOyHp0spdrDlaf4f8PTshaaTT7wso1NX9lfjvAW416u
         VV5FA5qhZRmPUXuBNWgFjhNncey479kx9NyHu0hISHRjhLdxlrzUUroMxEdThG+6Hl
         BaYCLctE/ixDw==
Date:   Tue, 12 Jul 2022 18:09:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH v2,net-next] net/sched: remove return value of
 unregister_tcf_proto_ops
Message-ID: <20220712180906.07bea7f8@kernel.org>
In-Reply-To: <20220711080910.40270-1-shaozhengchao@huawei.com>
References: <20220711080910.40270-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 16:09:10 +0800 Zhengchao Shao wrote:
> Return value of unregister_tcf_proto_ops is unused, remove it.

> -int unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
> +void unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
>  {
>  	struct tcf_proto_ops *t;
>  	int rc = -ENOENT;
> @@ -214,7 +214,10 @@ int unregister_tcf_proto_ops(struct tcf_proto_ops *ops)
>  		}
>  	}
>  	write_unlock(&cls_mod_lock);
> -	return rc;
> +

> +	if (rc)
> +		pr_warn("unregister tc filter kind(%s) failed\n", ops->kind);

I was saying WARN, by which I meant:

WARN(rc, "unregister tc filter kind(%s) failed %d\n", ops->kind, rc);
