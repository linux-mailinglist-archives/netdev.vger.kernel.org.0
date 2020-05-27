Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043971E4BFD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391245AbgE0Rfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387837AbgE0Rfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:35:39 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F235C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:35:39 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d2so2544003qtw.4
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5pjnryafVyy4mvARp4PLvV79vSG5/akHWFEPy2KlnO8=;
        b=dCGTihItQsGdYpyiMxMhs9bG07VqaX7OZDpHdEgQ/I0ws6IWqscrTrbKj7KnmVsugx
         L85ohmrQrYqgB5F/1TCwKCYf3AIZSNRBUSzHYw9Cv+cYNiaPGQTJOtCx6Iyy6r5S+Tga
         k3naGklZtQ4/a4uIwun19KNN7T+1Gu0qn2nCn/TxTvkB/XDzhBiAnAcJ6XDv2vi7oi1Y
         6j65zq5TwYq8Hp9V7VLehld2v2x9RUZLLvBHRu6pJzniue+UazeBwON5gfDoBqnduqAg
         zY+LIu4ln8I+LP3bWh1a+HzcJYPs8Q5Kgsry75N+g3/Y9nrTmpGzAZijFMX43oyWWwNH
         3aQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5pjnryafVyy4mvARp4PLvV79vSG5/akHWFEPy2KlnO8=;
        b=Wu+rKb6jHtbwpwdsYudGMy/Vz6OkYDdUz5zMgnF7Ik/k8wQ+FIoAAr/rlAzGbkao/P
         0fr54YMtXrtRHfYOPubn9KtlfacM5bZ798acUUUupkiSAj1fbfQj6QT7eAeXFOs11ryv
         3fnA+OhZVtn23ZbA2MyXtoiH9fBYOm4xaxkM7HE6aD8feW5EI8BGGr+R0J0Co0Bzsp2Y
         /I9CZxHSMqe4dvcD39W9q+4lBckqP6e86HY5aPa/iaFoXA7TuVbUQYa7I/7zXoSLCeOM
         Wmk+ZSpz4D7Pv0xONW0Ng4oRIBbv1xU8Msdt14CMVo/qC7oj/vts+TuYN9YP2I83EqB7
         5bpw==
X-Gm-Message-State: AOAM5329pFdoWLlxXtsYr/D5Fhkzcm5Z7tT8/MiBvkWoMkBUGi41sMP8
        4cJb6gdSjb7St9j/7CQ23Po0sDY=
X-Google-Smtp-Source: ABdhPJwP0e9h28WtLMf45Hus656qDYeDO+Q/IfiFF60rc2z7Uf9u2AXgp8ITZaNsqnb7aOyvExdPpjA=
X-Received: by 2002:a0c:fb0e:: with SMTP id c14mr12165721qvp.63.1590600938582;
 Wed, 27 May 2020 10:35:38 -0700 (PDT)
Date:   Wed, 27 May 2020 10:35:36 -0700
In-Reply-To: <20200527170840.1768178-2-jakub@cloudflare.com>
Message-Id: <20200527173536.GD49942@google.com>
Mime-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-2-jakub@cloudflare.com>
Subject: Re: [PATCH bpf-next 1/8] flow_dissector: Don't grab update-side lock
 on prog detach from pre_exit
From:   sdf@google.com
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/27, Jakub Sitnicki wrote:
> When there are no references to struct net left, that is check_net(net) is
> false, we don't need to synchronize updates to flow_dissector prog with  
> BPF
> prog attach/detach callbacks. That allows us to pull locking up from the
> shared detach routine and into the bpf prog detach callback.

> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
