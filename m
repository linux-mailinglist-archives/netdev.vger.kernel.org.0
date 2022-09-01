Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C335AA15F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 23:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiIAVNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 17:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiIAVNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 17:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0C88E4C1;
        Thu,  1 Sep 2022 14:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED6A61F6B;
        Thu,  1 Sep 2022 21:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3E5C433D6;
        Thu,  1 Sep 2022 21:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662066779;
        bh=gSRL2HcQIgMFn3GyqKSeX49RrRcw33oidasgkOg3Fqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AbdtEKwv8HVNJciiqJ3AcqqAJp2+PuYMg+GaX9r8Uavx/2ktgO/cd3Lf/nwIWPesp
         xiiqxVvHkN7HoiB6b3eWlvh6t9agHkvnV2Ti+fMLReTeAAUhHJ4xDqnmuF8PPVNwMt
         0M+mq8+45bT5Ajmlt54V5/0hgboRy3GxXlkak4cPKBO3/gO1PsdCDeKpkf2cXnG4/a
         eJg5czX9kTFoJQAK2kd1UYq4z0SHYwqsk6pp6npR9q0FbXnmrh6XD6fa3ZO0Zg4XD8
         ylVu8eIQ5VZYtHcK+AAbHVOU77Kzc+WLMydBIgvWCm6yq1nVJkB4FHpM6VY801lnan
         MTF0u3mepVaeg==
Date:   Thu, 1 Sep 2022 14:12:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
        rostedt@goodmis.org, mingo@redhat.com, imagedong@tencent.com,
        dsahern@kernel.org, flyingpeng@tencent.com,
        dongli.zhang@oracle.com, robh@kernel.org, asml.silence@gmail.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: skb: export skb drop reaons to user by
 TRACE_DEFINE_ENUM
Message-ID: <20220901141257.07131439@kernel.org>
In-Reply-To: <20220901152339.471045-1-imagedong@tencent.com>
References: <20220901152339.471045-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Sep 2022 23:23:39 +0800 menglong8.dong@gmail.com wrote:
> +#undef FN
> +#define FN(reason) [SKB_DROP_REASON_##reason] = #reason,
> +const char * const drop_reasons[] = {
> +	DEFINE_DROP_REASON(FN, FN)
> +};

The undef looks a little backwards, no? We don't want to pollute all
users of skbuff.h with a FN define.

#define FN....
/* use it */
#undef FN
