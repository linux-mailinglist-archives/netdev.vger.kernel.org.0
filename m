Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2944CA56E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbiCBNDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 08:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbiCBNDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 08:03:12 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B4F20F51;
        Wed,  2 Mar 2022 05:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1646226147;
        bh=tCuozGRQsDZceQ1EBnhysNv3YHpcwwqpdXYo/ZBImus=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=qDxd60XR5drJf8bwq63rj4X3X2qlNPHQf3xsbNStaSRkrLMLQuWdny2Zb7ZUu6hrO
         59+bXq4NPWia48Dvs3vS1lTFvL8YhhDiSUcahoOST03kgn/hbFldQO5umig3t21G9g
         QL3hyemqD189nDE4cHgv+E4OUoMDiC6fir0/ckCg=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 07FE11281285;
        Wed,  2 Mar 2022 08:02:27 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id P8Toy0NqOhgX; Wed,  2 Mar 2022 08:02:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1646226146;
        bh=tCuozGRQsDZceQ1EBnhysNv3YHpcwwqpdXYo/ZBImus=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=XuIbaRq2cRmudIn0tCjYzDQ6U6GgPDFdmFXykfNDiDeiID8tKhsyMNvIOr9tEecvG
         f4F3/soQI5AeLjUwOX08bACkE24xkbR2dRnM9zdf0ADOM+eldeC5LRWkG1XY0zL8Lm
         lECGSxIVJxOdDrF5MPICGQqUO4eLfv9vKF9NVeb4=
Received: from [IPv6:2601:5c4:4300:c551::c447] (unknown [IPv6:2601:5c4:4300:c551::c447])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id D7CFC1281216;
        Wed,  2 Mar 2022 08:02:25 -0500 (EST)
Message-ID: <c0fc6e9c096778dce5c1e63c29af5ebdce83aca6.camel@HansenPartnership.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        torvalds@linux-foundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org
Date:   Wed, 02 Mar 2022 08:02:23 -0500
In-Reply-To: <20220301075839.4156-3-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
         <20220301075839.4156-3-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-03-01 at 15:58 +0800, Xiaomeng Tong wrote:
> For each list_for_each_entry* macros(10 variants), implements a
> respective
> new *_inside one. Such as the new macro list_for_each_entry_inside
> for
> list_for_each_entry. The idea is to be as compatible with the
> original
> interface as possible and to minimize code changes.
> 
> Here are 2 examples:
> 
> list_for_each_entry_inside:
>  - declare the iterator-variable pos inside the loop. Thus, the
> origin
>    declare of the inputed *pos* outside the loop should be removed.
> In
>    other words, the inputed *pos* now is just a string name.
>  - add a new "type" argument as the type of the container struct this
> is
>    embedded in, and should be inputed when calling the macro.
> 
> list_for_each_entry_safe_continue_inside:
>  - declare the iterator-variable pos and n inside the loop. Thus, the
>    origin declares of the inputed *pos* and *n* outside the loop
> should
>    be removed. In other words, the inputed *pos* and *n* now are just
>    string name.
>  - add a new "start" argument as the given iterator to start with and
>    can be used to get the container struct *type*. This should be
> inputed
>    when calling the macro.
> 
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  include/linux/list.h | 156
> +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 156 insertions(+)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index dd6c2041d..1595ce865 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -639,6 +639,19 @@ static inline void list_splice_tail_init(struct
> list_head *list,
>  	     !list_entry_is_head(pos, head, member);			
> \
>  	     pos = list_next_entry(pos, member))
>  
> +/**
> + * list_for_each_entry_inside
> + *  - iterate over list of given type and keep iterator inside the
> loop
> + * @pos:	the type * to use as a loop cursor.
> + * @type:	the type of the container struct this is embedded in.
> + * @head:	the head for your list.
> + * @member:	the name of the list_head within the struct.
> + */
> +#define list_for_each_entry_inside(pos, type, head, member)		
> \
> +	for (type * pos = list_first_entry(head, type, member);		
> \
> +	     !list_entry_is_head(pos, head, member);			
> \
> +	     pos = list_next_entry(pos, member))
> +
>  

pos shouldn't be an input to the macro since it's being declared inside
it.  All that will do will set up confusion about the shadowing of pos.
The macro should still work as

#define list_for_each_entry_inside(type, head, member) \
  ...

For safety, you could

#define POS __UNIQUE_ID(pos)

and use POS as the loop variable .. you'll have to go through an
intermediate macro to get it to be stable.  There are examples in
linux/rcupdate.h

James


