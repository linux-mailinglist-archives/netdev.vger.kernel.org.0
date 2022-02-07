Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FC74AC419
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiBGPoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384370AbiBGPb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 10:31:56 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7A7C03E961;
        Mon,  7 Feb 2022 07:31:37 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id v74so13569132pfc.1;
        Mon, 07 Feb 2022 07:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=9brYQ3v7OVc6aEBTBtZMjzX9d5bnamj1rQekxmQrM9M=;
        b=I2Hf3GJxvNN4GRQH9kzLzxkqg8wf5jNqWqCXxsh1evsCBxY1LousIr1ABLvbNRpZC5
         HlYY5mDuvP2NKqMMC7qNafgtUw+Km/TojstZobIlg68g+0cQkjgZh17Y/nuEywZEYo7H
         x9+9GyWtPmINGOI7gSyEi+sEXPT6CPp3bA712Md2doEvBjSIszMyc/KbxqZIbBr1zmCV
         XX5Bdj1guw9UwtLRcdzGIMJiriiT0XVSl0OvDwrT8J2kXe3zR6e0dFETRcBxA9sVxRI4
         4pPQQKc4jXKe9ztRQlrGh52wXDeBaa7Usc67hbV/UZ2Kw/MIpXW/B0iO7gngV3Ayf3+9
         RoCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=9brYQ3v7OVc6aEBTBtZMjzX9d5bnamj1rQekxmQrM9M=;
        b=LahahQibRmZXcl0RimloLQ+Ak5YIEt34xGK2UB55ynszmTsNwGcXLF9UqzaaNNCgfY
         UdXaNW7TDNQlRqcwlleh1c/kC3Upo8/cI3C7di/cKfLiJtfp6clI+jLZ/g0/vOokl1BE
         D/zinOKyQZ580gmJJRMFPqcx4Wg2gek5YhSgdwN1stoDTx+Eiy6WOrVll1/1UQTLNvqO
         7XDGvkXGp4NH5P12pdbw7hM5/VektZ0KJuaO3flldEWb0GxCryL47lK3nygf8C80ia+O
         HhY5mwCie+13VNOUod4mjwuUGY2t2v3z75m+mmSV8LjcAaplzdtxbq18KedOZdoJ+5hx
         uO+Q==
X-Gm-Message-State: AOAM530eJj7NrfbJM0rp1mpDMNLzMXYDf/IzXEDsQ1nMd5cGlMjOe133
        rqsFloB4Dz+2NZVcwdxRUWQ=
X-Google-Smtp-Source: ABdhPJwGYDQw/0+EXbLlKn7bGPKQ8vZxLWGxgt4AIK9ImLm+DbN1g0CjOUZmNo8FI5+oxy/Ulb2i8Q==
X-Received: by 2002:a05:6a00:218b:: with SMTP id h11mr16337091pfi.29.1644247896825;
        Mon, 07 Feb 2022 07:31:36 -0800 (PST)
Received: from [10.59.0.6] ([85.203.23.80])
        by smtp.gmail.com with ESMTPSA id mn7sm2350149pjb.8.2022.02.07.07.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 07:31:36 -0800 (PST)
Message-ID: <fb543659-f69d-242f-b18a-69dd8b8b5ca1@gmail.com>
Date:   Mon, 7 Feb 2022 23:31:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     chunkeey@googlemail.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] intersil: p54: possible deadlock in p54_remove_interface() and
 p54_stop()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports a possible deadlock in the p54 driver in 
Linux 5.16:

p54_remove_interface()
   mutex_lock(&priv->conf_mutex); --> Line 262 (Lock A)
wait_for_completion_interruptible_timeout(&priv->beacon_comp, HZ); --> 
Line 271 (Wait X)

p54_stop()
   mutex_lock(&priv->conf_mutex); --> Line 208 (Lock A)
   p54p_stop() (call via priv->stop)
     p54_free_skb()
       p54_tx_qos_accounting_free()
         complete(&priv->beacon_comp); --> Line 230 (Wake X)

When p54_remove_interface() is executed, "Wait X" is performed by 
holding "Lock A". If p54_stop() is executed at this time, "Wake X" 
cannot be performed to wake up "Wait X" in p54_remove_interface(), 
because "Lock A" has been already hold by p54_remove_interface(), 
causing a possible deadlock.
I find that "Wait X" is performed with a timeout, to relieve the 
possible deadlock; but I think this timeout can cause inefficient execution.

I am not quite sure whether this possible problem is real and how to fix 
it if it is real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai
