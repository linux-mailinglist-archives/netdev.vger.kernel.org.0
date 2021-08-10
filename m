Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480FC3E5DEB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbhHJObS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:31:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229663AbhHJObR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628605855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwXLPkRqR+SsBFjswIeQqleOBf+7AdAAu2/54VZf3lI=;
        b=Nx2eae4kFZ/+1XGNxUzGcL92mdTCVaYvCDRyqdcidlI09rP0aEa15FTY/NOvQd85UqLt8z
        mlgPK+xZVdPhYK+pEotiKgPJSFE/9s3YRH9rl90wgt2g1RdS5C9iP9V0uVhXKOh0VdpQLo
        fm2D/EkDmyR2KAjvbn2OWExfyvr+4m4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-Bs9HAZVmM1GldmfzO0oNnA-1; Tue, 10 Aug 2021 10:30:53 -0400
X-MC-Unique: Bs9HAZVmM1GldmfzO0oNnA-1
Received: by mail-qk1-f197.google.com with SMTP id n71-20020a37274a0000b02903d24fa436e2so1232759qkn.3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 07:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AwXLPkRqR+SsBFjswIeQqleOBf+7AdAAu2/54VZf3lI=;
        b=URAmCLWKZu9HY7gXhuahwXQc0QZjDoci87l5ejWldBpJtnGMx6CSKco64R6pZu1CEP
         qyV0lGOVtb1sJEnZqr9iOHg+dHVqNYOcbhm0R2hkOpQbnEpXAsmscdYBc4Y1US5OD5m3
         ovcWw1T42JrQxnMcTAY7YEQAlg/LKGsPL9QI7UELj+M4rPDOzp8kdr9kLekOCNbTma1x
         38chFcfxhN+5axtkRN8o82/QmuqX6y9MaO0u86WIr+QVZrQVLoWGHrotJeu02Kx7REUo
         xmErTchFWJPbH/Ju49KspxMUnoMa7MyQj1Kaf7eXg/zPZsBI0WAtyCG4kCEvHWJD5amy
         Q2Vg==
X-Gm-Message-State: AOAM5324AGlV2FLE+gpT218GWEinjKN6viapjquTPQ240PJwkdz78zha
        nnNyg3+Yqs/56o40FYy6y5kdZI+Mgr6CwleY04bXeKQxd3/PZSNbBL3er4PMerxlQsJQT4OkdRk
        OG6FcLoH6cSylLOPt
X-Received: by 2002:ac8:7d0c:: with SMTP id g12mr25629000qtb.152.1628605853489;
        Tue, 10 Aug 2021 07:30:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvBJ8ktZM0ClSalr/V+CyOSaelGrWi4sfv6Noi2qvxyB2Q09/eh2rleVQ8IfL7nZ1iGfCSyg==
X-Received: by 2002:ac8:7d0c:: with SMTP id g12mr25628984qtb.152.1628605853339;
        Tue, 10 Aug 2021 07:30:53 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id bm34sm10612094qkb.17.2021.08.10.07.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 07:30:52 -0700 (PDT)
Subject: Re: [PATCH net 2/4] ice: Stop processing VF messages during teardown
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org,
        Konrad Jankowski <konrad0.jankowski@intel.com>
References: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
 <20210809171402.17838-3-anthony.l.nguyen@intel.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <f603a18a-20d3-59d1-ac6a-6967e7823497@redhat.com>
Date:   Tue, 10 Aug 2021 10:30:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809171402.17838-3-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/21 1:14 PM, Tony Nguyen wrote:
> From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> 
> When VFs are setup and torn down in quick succession, it is possible
> that a VF is torn down by the PF while the VF's virtchnl requests are
> still in the PF's mailbox ring. Processing the VF's virtchnl request
> when the VF itself doesn't exist results in undefined behavior. Fix
> this by adding a check to stop processing virtchnl requests when VF
> teardown is in progress.
> 
> Fixes: ddf30f7ff840 ("ice: Add handler to configure SR-IOV")
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Assuming only the commit message is fixed up.

Tested-by: Jonathan Toppins <jtoppins@redhat.com>

