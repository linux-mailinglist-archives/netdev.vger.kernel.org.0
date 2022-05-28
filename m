Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E643B53699D
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355337AbiE1BOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiE1BOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:14:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42577122B69;
        Fri, 27 May 2022 18:14:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B938F61B6B;
        Sat, 28 May 2022 01:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419CBC385A9;
        Sat, 28 May 2022 01:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653700468;
        bh=rTYJv8jXTriCoHR9T+nXzqG+J0Zbs8O4Ly3nJx6dWcs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o5414BETX5KriRkmLAeW11oLaGwOkGcFraMiGwOq8sAHmE3F273UeDmaZqAzKn4Kd
         kPhjAbnq8XiJ7bvEVpcN9cBzPMHRq3ncHtFwkRCzKgvmbGTPH2/qt9AGqYnCu3m9ag
         AaD1Lk041XfEBUY04X0USPDqPkb4Sj2F5+h1t5t6sWn28J4ORMQpa16dBW2Ov9rQLW
         VffIKZgwUWFMNRLi6atvctitPBtsyk2nResrVi/NXm2nAORNtNlFA2UA+oL9q0Kr9U
         syIYRP7uY8jkfnBoIzkkLHWpH8OqxQhiW+w0QdYohcckEHF9QIfc6yQur9m9Dz8QuB
         wngxRqgwHI+lg==
Date:   Fri, 27 May 2022 18:14:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nhorman@tuxdriver.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: skb: use auto-generation to convert
 skb drop reason to string
Message-ID: <20220527181426.126367e5@kernel.org>
In-Reply-To: <20220527071522.116422-3-imagedong@tencent.com>
References: <20220527071522.116422-1-imagedong@tencent.com>
        <20220527071522.116422-3-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 May 2022 15:15:21 +0800 menglong8.dong@gmail.com wrote:
> +clean-files := dropreason_str.h
> +
> +quiet_cmd_dropreason_str = GEN     $@
> +cmd_dropreason_str = echo '\n\#define __DEFINE_SKB_DROP_REASON(FN) \' > $@;\

echo -n

> +	sed -e '/enum skb_drop_reason {/,/}/!d' $< | \
> +	awk -F ',' '/SKB_DROP_REASON_/{printf "	FN(%s) \\\n", substr($$1, 18)}' >> $@;\
> +	echo '' >> $@

Trying to figure out when we're in the enum could be more robust
in case more stuff gets added to the header:

 | awk -F ',' '/^enum skb_drop/ { dr=1; } 
               /\}\;/           { dr=0; } 
               /^\tSKB_DROP/    { if (dr) {print $1;}}'

> +$(obj)/dropreason_str.h: $(srctree)/include/linux/dropreason.h
> +	$(call cmd,dropreason_str)
> +
> +$(obj)/skbuff.o: $(obj)/dropreason_str.h

Since we just generate the array directly now should we generate
a source file with it directly instead of generating a header with 
the huge define?
