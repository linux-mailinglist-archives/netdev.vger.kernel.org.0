Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2F943E40D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhJ1Oqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhJ1Oqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:46:33 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1D0C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:44:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t7so6573686pgl.9
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NWGAsPYeLjcm5PERO8zKrtVgrxW4eCdFt7j8ZoVJnc0=;
        b=Vp+GgUs3dr8p0EWA9uAOpafHIzUrKA1AWdhZnt6PuFXNbwkNGfPb9uq2FnNZCF93pt
         WMUuErhBtalxfzE778gu97Qe4wn16BIJURogBPd+9QFOTp7h8FPcrW6edEa/GqJElDEc
         +94ptOZpt5d3V+k1kJwr+qTY1o5F5VQH4Fx3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NWGAsPYeLjcm5PERO8zKrtVgrxW4eCdFt7j8ZoVJnc0=;
        b=JXZUxdUIuxLSrSI4hyjJ3Fztw77wHAbK/HPIf3C/jLXHwNU6HCSWLyMWZWmV5LlPVR
         enFqmd5OaPYCCo36zXKX/z3flxQ7Mg22cUbnkv2S2W2z7dJePWIR52APzN8u6zj4ecjf
         paYxQL2OyViBqQscgasSjTRAER2+1AYWPCCBrlQbEMR4zR1GT/Bh0fA+nHmzlMlFKkW3
         sbghnKnW6DZKpQ81tY/3GZerpjA5k9raBHhzG3VcGmLfLbivhIRX4eKbnUwyyiEo+sP1
         bIP0TIEQoz5HzoZ2idGBiWDXFTnPpq0jKXA7ovYnrlMs7c5Bk4jnU5xj5JrN2kz+GWOw
         s9tA==
X-Gm-Message-State: AOAM5303Xsiv9ES9vvAuKCxhgttX6qyICy93VeJHcHvDTCmWa/ggDhjz
        NRmdPlxRcwVaM1D7IESXPyphcA==
X-Google-Smtp-Source: ABdhPJyPe/Zo6SrrrzMpSbKfnEilV8486XrmLi6Q6oiHQWGuhtk3+KPA3pyMnSF9vDFv4JdyTeyoLg==
X-Received: by 2002:a05:6a00:1a46:b0:47c:2de5:4efd with SMTP id h6-20020a056a001a4600b0047c2de54efdmr4857753pfv.12.1635432245758;
        Thu, 28 Oct 2021 07:44:05 -0700 (PDT)
Received: from cork (c-73-158-250-94.hsd1.ca.comcast.net. [73.158.250.94])
        by smtp.gmail.com with ESMTPSA id m15sm3312986pjf.49.2021.10.28.07.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 07:44:05 -0700 (PDT)
Date:   Thu, 28 Oct 2021 07:44:03 -0700
From:   =?iso-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Caleb Sander <csander@purestorage.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Tony Brelinski <tony.brelinski@intel.com>
Subject: Re: [PATCH net-next 1/4] i40e: avoid spin loop in
 i40e_asq_send_command()
Message-ID: <YXq3M5XvOkpMgiOg@cork>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
 <20211025175508.1461435-2-anthony.l.nguyen@intel.com>
 <20211027090103.33e06b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXqOL0PqhujmH+sd@cork>
 <20211028072607.4db76c84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211028072607.4db76c84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 07:26:07AM -0700, Jakub Kicinski wrote:
> 
> The status of the command is re-checked after the loop, sleeping too
> long should not cause timeouts here.

Fair point.  usleep_range() is likely the correct answer in this case.

Jörn

--
It is the mark of an educated mind to be able to entertain a thought
without accepting it.
-- Aristotle
