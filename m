Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C59183DEC
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 01:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCMApX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 20:45:23 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46737 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgCMApX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 20:45:23 -0400
Received: by mail-lf1-f67.google.com with SMTP id r9so932492lff.13;
        Thu, 12 Mar 2020 17:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kyK0YBHskOgIKQSvIztL8mILUOxuA/vxRVW0kljPsHo=;
        b=DfKMpgeiqkMSE2dLQ1+U/kYzwYwsxqrxBGZVLID1BDEc7xv70BJQ+SfMNYxoMRU0Kb
         HUoblCSyNVbLX19PZDGVUE+E2hY6LI8WNiwTQ1s+ik5NY31G35bfzN5+7vC7tYgSXMAD
         X08fPhLP/7tJ5ynop7lECkBuSOTnyoWLrHbq6dgL3F67L/v5jh74iZOcx+5LxgNrUYkW
         PJIjK2GOF8t52gYjPwsXDfoZ2XvZQfL/qEJaMeXOWMAg4zvcPPHOvPN8qx4z8lI84LGf
         LD1wpt56uRJmWGG7KRKw0BvMkwXozSUsOumrdoApEa4tN1GhJTi/V9/5nua6yeArK3fM
         biTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kyK0YBHskOgIKQSvIztL8mILUOxuA/vxRVW0kljPsHo=;
        b=ghGQZ3LcLIpZlj6ONI9n6Ay1/3yo+Ywty8vIjj+WIHFwSC608QG0xfvT6KYteP3g/Z
         OPRNUcgTQmgPE4QM1s/qik2uVH6szDdiN7Wh0gtojghlu6842nDzyEHMZcTnhErYki+2
         DdofWo4RN87K6cwiT6L/EOiB8G11ZYFJXGMGVvrwLM/9R8Niptb3WmkVtHo5qY6ZvZXF
         JnkUGrJAeI2AD8mWoBtWQ2gwXc2LiISGd04ZS+QybHaThOL1eAakwUKhbqfoKIzNd/UU
         Vf69lksf3vUnlnXo/TG6qPMjM5DWxk7l4MzLrZLnGU9urgk7SJarzAzYzhP+GnCewcCp
         T25w==
X-Gm-Message-State: ANhLgQ3kvR3lE3WNqv7T52lmhrhzZZH+UrycMYptN/IcVpD4DSea+9Bh
        Kd4XYppSA1qIgSmIEDByWuWBoKOMxGu2r9KmuRs=
X-Google-Smtp-Source: ADFU+vswErnchRKK/84z4Qfn8s/fYd3ACeHTeG30jOlE0WXRoxheVJyr23v829w5kzR+caGBKStyCtyoE14z/ke0sAE=
X-Received: by 2002:ac2:4d16:: with SMTP id r22mr6687217lfi.174.1584060320720;
 Thu, 12 Mar 2020 17:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200304204157.58695-1-cneirabustos@gmail.com>
In-Reply-To: <20200304204157.58695-1-cneirabustos@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Mar 2020 17:45:09 -0700
Message-ID: <CAADnVQL4GR2kOoiLE0aTorvYzTPWrOCV4yKMh1BasYTVHkKxcg@mail.gmail.com>
Subject: Re: [PATCH v17 0/3] BPF: New helper to obtain namespace data from
 current task
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 4, 2020 at 12:42 PM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
> scripts but this helper returns the pid as seen by the root namespace which is
> fine when a bcc script is not executed inside a container.
> When the process of interest is inside a container, pid filtering will not work
> if bpf_get_current_pid_tgid() is used.
> This helper addresses this limitation returning the pid as it's seen by the current
> namespace where the script is executing.
>
> In the future different pid_ns files may belong to different devices, according to the
> discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
> To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
> This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
> used to do pid filtering even inside a container.

Applied. Thanks.
There was one spurious trailing whitespace that I fixed in patch 3
and missing .gitignore update for test_current_pid_tgid_new_ns.
Could you please follow up with another patch to fold
test_current_pid_tgid_new_ns into test_progs.
I'd really like to consolidate all tests into single binary.
