Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B53166A2ED
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjAMT2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjAMT2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:28:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C6C88A2F;
        Fri, 13 Jan 2023 11:28:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E687762309;
        Fri, 13 Jan 2023 19:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EBDC433A4;
        Fri, 13 Jan 2023 19:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673638099;
        bh=oGTM2wuzaiQf3hnu49bV1kw3D+nqr4DgGLcbnBAxXKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BENo1rWjURBUnC+mPcISq8IxkaNLrBFhEWK/AYiGE4tfQSoIP1w7gus2p5DUO58jW
         jv3F53pjzER1/aDCTJy+eaI6vv+SvSB6rY7AY3QoJAiGcUyiBYYuAoKYG3FygH/6UD
         y3WGEOSdP5B69oCN27m7Y7eDW2ScRFNhwIHtZ1IXBFfRY4yqhGu2sxfORzFXL/ww5j
         xS3Rewt5XXYAAhLw6oPB3cjhIIb0yFKyCSOJV690iyL8fTiXf0OGHwm+md7BP5aLhh
         9k+szzOCOhj77HSBUrxPI385z7729wyoZ6Fc7H9hrFCQOkTtYehgo3DNAR/20pLiRu
         zY7INFFg05oeQ==
Date:   Fri, 13 Jan 2023 11:28:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>
Subject: Re: [PATCH net-next v2] net/rds: use strscpy() to instead of
 strncpy()
Message-ID: <20230113112817.623f58fa@kernel.org>
In-Reply-To: <202301131513124870047@zte.com.cn>
References: <20230112211707.2abb31ad@kernel.org>
        <202301131513124870047@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023 15:13:12 +0800 (CST) yang.yang29@zte.com.cn wrote:
> > What are the differences in behavior between strncpy() and strscpy()?  
> 
> Strscpy() makes the dest string NUL-terminated, and returns more
> useful value. While strncpy() can initialize the dest string.
> 
> Here we use strscpy() to make dest string NUL-terminated, and use
> return value to check src string size and dest string size. This make
> the code simpler.

I'm not sure whether in this particular case the output needs 
to be padded or not. And I'm not sure you understand what the
implications are.

The code is fine as is, and I don't trust that you know what 
you're doing. So please don't send any more strncpy() -> strscpy()
conversions for networking.

If you want to do something useful please start with adding a check 
to checkpatch to warn people against using strncpy() and suggest using
strscpy() instead.
