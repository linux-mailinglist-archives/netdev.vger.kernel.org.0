Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963D93FE110
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344594AbhIARUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344515AbhIARUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:20:08 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C83CC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 10:19:11 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u14so570599ejf.13
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 10:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eq5Vg9W6sGnKD0EHXOKdtWvtTSLKbCF83MIL/W3N0fU=;
        b=YeoowJ1oD0AjxPC6rG4kVaDATZ6L6f1Uu9+fQHYmZvaxopiEX0msbU4g2f1thzcAPJ
         pJ+uxSRA4/Qx/98p5QMlxR1ZlIMrC4T3GsCu7oYMoKASgapJKV/PsUJqjQeU3cNf+VRU
         NnB4EJ5ekxKrWLXTffsOsZIfSkqSxZTUc8TE/nmLApwyGRxtjubZNATA5p7wGBDzSLjk
         sny9vLJuySz89yYy1vTFfS+CIrvxF9rd85+doxOf6EvhPr4lHVImkWOChd2Xm4HsK3zf
         Fl+oIrtA98NS+xXGFvKTnzUbTmctbOYz7A5CeZ9QW3AGekL+8bzYnviROo67/ManK7Fb
         dTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eq5Vg9W6sGnKD0EHXOKdtWvtTSLKbCF83MIL/W3N0fU=;
        b=SHQrkt0nkk6G2hshAxszIdL2MwTg3JkXaOSG2Ah9OSKCrzR4yRiKakMzYaw8Uf8V3p
         +x1S6DDyITXrPdvc7HA8T5aHkfEvFPYbzQ8KHXW/cU+sMs3KrW6fo7B9xBWX/EwIo943
         uBNJjBGXHVm+ny5Ja54LdxwPVBp7/whI7Nm6fw+irg4SuzBRps81Jpb66xdtv50VxXi7
         tvwbN/e2Dm/eruHUIcb2IgE0TPa0CwUcjSbQZlvLB7EMlKmtkKpn7hoxm92XdgkDB+mb
         uPTqVMBVdcvdQKBjrVio0wje5KwHpkkCSX9P8FKi7Q3gYxwJiqXb3u/Jt/IrJsZLi2+9
         So2A==
X-Gm-Message-State: AOAM530pZ3/Vn7SF1hbLLbAYVSNEW1SF/E0FPEeykCg3YkaWylzr12Ip
        BnJ0h2iYAST+xaxe44zHPg+1Jv2+sOZdhQ==
X-Google-Smtp-Source: ABdhPJxrn2jcdQJQWWys1OBFPMojsRHsQIMzMyxT2gE1rBQzIXFiQ2XH/8zNlPl2qw+w3A4uqyR3qA==
X-Received: by 2002:a17:906:9b1:: with SMTP id q17mr561718eje.546.1630516750184;
        Wed, 01 Sep 2021 10:19:10 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (94.105.103.227.dyn.edpnet.net. [94.105.103.227])
        by smtp.gmail.com with ESMTPSA id p18sm156845edu.86.2021.09.01.10.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 10:19:09 -0700 (PDT)
Subject: Re: [PATCH net v2 0/2] mptcp: Prevent tcp_push() crash and selftest
 temp file buildup
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
References: <20210831171926.80920-1-mathew.j.martineau@linux.intel.com>
 <b9fa6f74-e0b6-0f61-fc5a-954137db1314@tessares.net>
 <20210901101613.50a11581@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <146f94a7-77e8-ced9-fcb3-adc2d33ff0aa@tessares.net>
Date:   Wed, 1 Sep 2021 19:19:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901101613.50a11581@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 01/09/2021 19:16, Jakub Kicinski wrote:
> On Wed, 1 Sep 2021 18:09:52 +0200 Matthieu Baerts wrote:
>> Git auto-resolves conflicts. Is it why it is considered as "Not
>> Applicable" or did we miss something else?
> 
> We don't enable 3-way merges for patches applied from the list, usually.

Thank you for your reply, we didn't know that, that's clearer!

>> Do we just need to resend these patches after a rebase?
> 
> Yes please.

Just did, thank you!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
