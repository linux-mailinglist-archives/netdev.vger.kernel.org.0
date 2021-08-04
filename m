Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642B93E0642
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239764AbhHDRAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239640AbhHDRAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 13:00:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F303DC0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 10:00:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so9707991pjs.0
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 10:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sqIbrRSKxcewBNT00a4KK0eQBLjFurI1/+zQ7attBYA=;
        b=RhCQOyH5kufck9DSwsk6bWhCQWb21Gzd5BabWRmSKCAlYSiG8+710TjxW+0aFERJtj
         6HzPe11AsYAlm85lwLDD82xg88GYG0XXGLQ9v3TWtjurol/LN2ftLeKuI2lntzuRodib
         l+hq1BWtpaqQAbz5h/C/VdzD7WFZqGtpMuGK/VfGEDNR7AJArBUpn9BplpoGwsKQw8ct
         AzbVSNWdW8VdxNoH+ZjTZ+8vsDgNOCcm0lZ/uIGZCbkuhU3qAeic+9bHWSsxwbVFdYon
         9f3FLrFavyTKzZxa2iGIFJjPU73TSCmqH9BTBIwRUBEUaCNb1TCFELbS0SiB23ofy78T
         LjWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sqIbrRSKxcewBNT00a4KK0eQBLjFurI1/+zQ7attBYA=;
        b=MRzGeBC5IeH9AtWwOEors2yxu1JAXlTUdNdp+3aI/rDsszIJVmPNk/rrMS/OLuLcFH
         AVbgcx4SEFPVNmpXPd8bcHlfHFl/OP+3Qk1wYYYs9D8/4mSg+/pxzE4N0G4Ghtd6RA6z
         eqPx8BpHiOjnpCdMAhwHXt47D6pJWXr0vRrG6u9MVm0e56niZHURYEUCyVWw202J8v3D
         UnCORy4KhnBhILqitQSxea/eHfovO/C2YfiqtpZIdX51qf1NePCrmYommI/zT//0KBVq
         IjIqlWIQ2l/zomFq1Z1DhvFzbuAJohy/ou1pCV0hkUGZWOLNw4cGnmdSpMj8JDDe9vRM
         IWcA==
X-Gm-Message-State: AOAM533x6Pw2B+qw79GNW8Pz/FTa1qO2jfbD0PNZv2x3vuTf5xAtFhtw
        X5q+DOAjpz40Awu4vVr6ey9PHPMW6TCG+Lxw7eHmZA==
X-Google-Smtp-Source: ABdhPJyD/4Kcsvlztp9G6aHU/T9caj1jYYp/DLDeiJWSfXC9AuqoSKxXn91Kc0t1KX4nNGtevdxv3XpSJyjMAziMaM8=
X-Received: by 2002:a63:1661:: with SMTP id 33mr88026pgw.443.1628096409551;
 Wed, 04 Aug 2021 10:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com> <20210804160952.70254-5-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210804160952.70254-5-m.chetan.kumar@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 4 Aug 2021 19:09:52 +0200
Message-ID: <CAMZdPi8Fotq3z8ET+3dfQjPuUSX8Lna5dqF4jDsbTxf5bePWDA@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: wwan: iosm: fix recursive lock acquire in unregister
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021 at 18:11, M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
>
> Calling unregister_netdevice() inside wwan del link is trying to
> acquire the held lock in ndo_stop_cb(). Instead, queue net dev to
> be unregistered later.
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
