Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD1713E20
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfEEHT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:19:56 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36668 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEEHT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:19:56 -0400
Received: by mail-lf1-f66.google.com with SMTP id y10so346451lfl.3;
        Sun, 05 May 2019 00:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rqjkexR6cKEvg4nJFIESH0EoiMBEnFjwHJlnCdqLAog=;
        b=C0/rbRj2NttQ1SxFzRYc2iCq6fDLNe999e6o44mbbCY61LNopJn1Uks2DrNzxmiDYE
         RoGeTjUqv6EcO72idFZjXfAzI0GdILyp0Cj9iFzcEPJ/ASDmuACN0/sjEgZU0g/3i2ez
         pUDwg30foReGTiIuc/z7gn5KOaI4zpZ31Op+06FOy921Q1EF/mGIYbJapPEhGdzgdDMz
         bI9HqvJZtaIZvPjavu/NP+tUjU0n49bQe2q3KHNeLTdm/qleTTMSbpBmDcztW5mVLvcG
         /lqkym7EhG/UnPpNs+kH2Z6YKID8ynKf7uB2PTiIRklrUQj4kfKl5YsdlmeyxyrSDLRQ
         5mQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rqjkexR6cKEvg4nJFIESH0EoiMBEnFjwHJlnCdqLAog=;
        b=S/EWMflfkAG3JwUY3L/tCii+PnMf5BDMto4+YfTUcVRupPJzqWONIbIJx3A35MlzwW
         TLPollOLTuVXbR5GBOzz1kGZOJ/7ZjbALLdFzvzcn7CdQ5VziRzKv7Cny/XBkmbGQv3/
         Ie3txsix/ynQ3l6vrn+bLPIU5w0Mj3kj9mwGYmMXTFfvokbcW9zNYB6D5r5NDGcL6duX
         0iPf7neyr2gUfdhku7atoJmDzNFa20VX1fhZNPskizcrhTerSwARmm6ykjK9IJKUDXW7
         CUncXKYXqfX8Nq1QsRCrZHX9cRuAvV0JhleuukTb9/sOC6Vc00iwZIIVUu2CL4eC+T5M
         3PsQ==
X-Gm-Message-State: APjAAAWUHbOufWwwbvTsbMNGWTDzubGSpvERPnPnRLqF50uQ+KLNmbo7
        EDOHWjNm+LISBUEyGsHnMziQSQ++a/D0k7ZyKWw=
X-Google-Smtp-Source: APXvYqwFQhM5ABO4riWQ975YCk1BrEft4WJ7z/th+uvqIylKlHSgryaHZFy1E/4VJvIzhehP5uwU1CCUWxmG1uKWfJE=
X-Received: by 2002:a19:c216:: with SMTP id l22mr9436689lfc.112.1557040794052;
 Sun, 05 May 2019 00:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190502204958.7868-1-joel@joelfernandes.org>
In-Reply-To: <20190502204958.7868-1-joel@joelfernandes.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 5 May 2019 00:19:42 -0700
Message-ID: <CAADnVQ+CPXKv_fryOxnDXjCLmWxor2j+WBFvPtG-Tcyr=hzRpQ@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 1:50 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> The eBPF based opensnoop tool fails to read the file path string passed
> to the do_sys_open function. This is because it is a pointer to
> userspace address and causes an -EFAULT when read with
> probe_kernel_read. This is not an issue when running the tool on x86 but
> is an issue on arm64. This patch adds a new bpf function call based
> which calls the recently proposed probe_user_read function [1].
> Using this function call from opensnoop fixes the issue on arm64.
>
> [1] https://lore.kernel.org/patchwork/patch/1051588/
...
> +BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size, const void *, unsafe_ptr)
> +{
> +       int ret;
> +
> +       ret = probe_user_read(dst, unsafe_ptr, size);
> +       if (unlikely(ret < 0))
> +               memset(dst, 0, size);
> +
> +       return ret;
> +}

probe_user_read() doesn't exist in bpf-next
therefore this patch has to wait for the next merge window.
At the same time we would need to introduce
bpf_probe_read_kernel() and introduce a load time warning
for existing bpf_probe_read(), so we can deprecate it eventually.
