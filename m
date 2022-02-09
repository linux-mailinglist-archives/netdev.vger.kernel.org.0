Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D7C4AE78C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 04:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbiBIDD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 22:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359764AbiBICvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 21:51:25 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C133C0612C2;
        Tue,  8 Feb 2022 18:50:48 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 10so1028045plj.1;
        Tue, 08 Feb 2022 18:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=h0zU2sqp9DInM9RIto6tdU+ZDVJECbmLRz9DGlSBkQA=;
        b=S+1HXZWBrFY+m0WszgouwfuXg8ZAQ+U1QGmFDQYqZvgyCeBFwx4xfexAqZ3a0cCgj2
         d6ghHdTCktl0vbeo6k/ifXLCc6fNgo8L39m4ZnomSvwp5SxXi0GnKHKxmduLBMWUW8sm
         zBbrM0J7YHJzy+LPt24oQpBsEma2qSfxhHCHnI4BTRVXwIpWU0rotWSUCk4HNJOksbK+
         lRQOmYYAZH3h8SgPM6TeciIdyIOLuL9h022UvXV6A7ynjKWebIlY9DsM8PrXnArqI+p7
         aCYY04cCte0FVJE2jtc++l3ne/7LLcxTA5Hh3vRhzh0OTBmW4kKDMGuIIl76QwByzxpt
         vtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=h0zU2sqp9DInM9RIto6tdU+ZDVJECbmLRz9DGlSBkQA=;
        b=6X0QuXo8+pw7gZ9TQcOlNIgUnJBPlYmhmynjUqGsB6Ete+tgCxQYDGgYKr3L3Tugy9
         DUROw4k3hEjWJFGsGZ2/I9FzDU0v9FeXe1WpLd8fAa3GOEGO1d/mj/ehphhWjpnkW/fy
         +BSLJA15gyjW49O0eXRve6abxpZSq1fbXvPAagsNyc1vWZEceNlbf0K8E8XsdYQF1DPH
         xffkTSqsH1U7ThqlHHb8jWfwYAHvVfmygz71guxqEgBWBL2F4/izTHg4MbX3Fhy2BHMp
         5WqtjSw1mL2ALRncxSNb3fw65vRFoPVOJjVEKRD3pNZL2n4GAGhRorrPrQZL9MHhHpT2
         6oFQ==
X-Gm-Message-State: AOAM530Ll8z5z71NoxMAleeWcKPkID8W1TARFjHF2De/71QhBE6//aX/
        DzWKZApaJApcYLOJK7Px2wHKJKumd1s=
X-Google-Smtp-Source: ABdhPJykVboULllJsI40xKPv9LbYcg5sq9410WhmFuByGFlzuxSllka4Pnp4oEshsoXzZvhpxWgMAA==
X-Received: by 2002:a17:90b:23c9:: with SMTP id md9mr1082313pjb.173.1644375047431;
        Tue, 08 Feb 2022 18:50:47 -0800 (PST)
Received: from [192.168.1.100] ([166.111.139.99])
        by smtp.gmail.com with ESMTPSA id r7sm6944390pgv.15.2022.02.08.18.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 18:50:46 -0800 (PST)
To:     simon.horman@corigine.com, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, shenyang39@huawei.com,
        libaokun1@huawei.com
Cc:     oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: netronome: nfp: possible deadlock in
 nfp_cpp_area_acquire() and nfp_cpp_area_release()
Message-ID: <922a002a-3ab6-eabe-131c-af3b8951866b@gmail.com>
Date:   Wed, 9 Feb 2022 10:50:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
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

My static analysis tool reports a possible deadlock in the nfp driver in 
Linux 5.16:

nfp_cpp_area_acquire()
   mutex_lock(&area->mutex); --> Line 455 (Lock A)
   __nfp_cpp_area_acquire()
     wait_event_interruptible(area->cpp->waitq, ...) --> Line 427 (Wait X)

nfp_cpp_area_release()
   mutex_lock(&area->mutex); --> Line 502 (Lock A)
   wake_up_interruptible_all(&area->cpp->waitq); --> Line 508 (Wake X)

When nfp_cpp_area_acquire() is executed, "Wait X" is performed by 
holding "Lock A". If nfp_cpp_area_release() is executed at this time, 
"Wake X" cannot be performed to wake up "Wait X" in 
nfp_cpp_area_acquire(), because "Lock A" has been already hold by 
nfp_cpp_area_acquire(), causing a possible deadlock.

I am not quite sure whether this possible problem is real and how to fix 
it if it is real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai
