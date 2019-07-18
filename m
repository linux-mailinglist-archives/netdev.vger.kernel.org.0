Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C316CF2D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 15:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390530AbfGRNvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 09:51:05 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38657 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbfGRNvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 09:51:05 -0400
Received: by mail-lj1-f195.google.com with SMTP id r9so27423093ljg.5;
        Thu, 18 Jul 2019 06:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=1BOBfJjzAO1ncQLuZBsQ1y8vAYf9kKWTQWjBVQihWco=;
        b=dHyse0OlMCR4dZAzAAy2KlktQbXcOjLVPAOst3rFciJTqSnSxShtGX4cZEhASN6Md8
         mEPhZljNWjS+gaNti3Nhzt2pTEWpt1psSiSVfMRtJHzCQIlxHUDAjayBw9J4/zMgvioR
         gqYwDm9oAms8jXfZjPfcquZpbVP7zgN70pd1UVO9T9Owt8sDq6bzsGsvOaE2GDTD2KJi
         PRb5qKo+4Uc7CngWgl6cooCenuqmBj9WE62JVFIjbzrpbALjrNXhIZk8RgGfOU/xyN1p
         qKB/1I6AO8oWujv8oJjxVJQRRNwd4p22+G6zmTGOjz7IaqhAqgAl/C7hnCcYGIM5ucoW
         I6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=1BOBfJjzAO1ncQLuZBsQ1y8vAYf9kKWTQWjBVQihWco=;
        b=F8dLLiqZL7k5QTKuDfHypuPYjEWY+HPJ0Cs1XRza+AAhXPDPUSPgCWi3AT8uXbuyxk
         BeuOpwRcl/tCaZdrI6D1cdLqyYHlR1QbXZfpmIW6MAyVnA+sW5HtWAQAWQMjKU0YDS77
         K3+k68mD+Uf2cNU4Cef7C938R+DaxKqzxxMfOt/rlftYWy4AcqRwjV/gZ21jiUgsaL+x
         HnUxbVJNMn1qnRNHAFyjC1wG5vkGZvaov8vxgl9gPLlqlIEza1jUwg5mXrcTN0fCu15u
         ecdi5fkVClJkXXsBTid5wqVni6vea9FTIk9M2Cq9408VWkicu9EtO9PnsefkubVnyEAE
         D5Qw==
X-Gm-Message-State: APjAAAVy6O2rTU815Q9jgfXCwrH6vHAEo886/VfrN5s7ynHKrnih5pSd
        ETyYaunPKvrMYRYTzt5ZX1Uss2L2aK8io/li0BE=
X-Google-Smtp-Source: APXvYqxt/0B7BmQXX4nJWn8Apr06RMr6QZRBEqRaQXynp22L7R1W2vLTcurN1dI9F092AnQEmnQ/OKbzBhiLIf5IAz8=
X-Received: by 2002:a2e:8155:: with SMTP id t21mr24203961ljg.80.1563457862034;
 Thu, 18 Jul 2019 06:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190718020745.8867-1-fred@fredlawl.com>
In-Reply-To: <20190718020745.8867-1-fred@fredlawl.com>
Reply-To: bjorn@helgaas.com
From:   Bjorn Helgaas <bjorn.helgaas@gmail.com>
Date:   Thu, 18 Jul 2019 08:50:50 -0500
Message-ID: <CABhMZUWX055ysYoy7CyFoKE1DCCrGnQXuh9cEqNHk4r5Se+5fA@mail.gmail.com>
Subject: Re: [PATCH] cxgb4: Prefer pcie_capability_read_word()
To:     Frederick Lawler <fred@fredlawl.com>
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 9:08 PM Frederick Lawler <fred@fredlawl.com> wrote:
>
> Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
> added accessors for the PCI Express Capability so that drivers didn't
> need to be aware of differences between v1 and v2 of the PCI
> Express Capability.
>
> Replace pci_read_config_word() and pci_write_config_word() calls with
> pcie_capability_read_word() and pcie_capability_write_word().
>
> Signed-off-by: Frederick Lawler <fred@fredlawl.com>

Nice job on all these patches!  These all help avoid errors and
identify possibilities for refactoring.

If there were a cover letter for the series, I would have replied to
that, but for all of them:

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

If you post the series again for any reason, you can add that.
Otherwise, whoever applies them can add my reviewed-by.

> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 6 ++----
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      | 9 +++------
>  2 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> index 715e4edcf4a2..98ff71434673 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> @@ -5441,7 +5441,6 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
>                 char name[IFNAMSIZ];
>                 u32 devcap2;
>                 u16 flags;
> -               int pos;
>
>                 /* If we want to instantiate Virtual Functions, then our
>                  * parent bridge's PCI-E needs to support Alternative Routing
> @@ -5449,9 +5448,8 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
>                  * and above.
>                  */
>                 pbridge = pdev->bus->self;
> -               pos = pci_find_capability(pbridge, PCI_CAP_ID_EXP);
> -               pci_read_config_word(pbridge, pos + PCI_EXP_FLAGS, &flags);
> -               pci_read_config_dword(pbridge, pos + PCI_EXP_DEVCAP2, &devcap2);
> +               pcie_capability_read_word(pbridge, PCI_EXP_FLAGS, &flags);
> +               pcie_capability_read_dword(pbridge, PCI_EXP_DEVCAP2, &devcap2);
>
>                 if ((flags & PCI_EXP_FLAGS_VERS) < 2 ||
>                     !(devcap2 & PCI_EXP_DEVCAP2_ARI)) {
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> index f9b70be59792..346d7b59c50b 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> @@ -7267,7 +7267,6 @@ int t4_fixup_host_params(struct adapter *adap, unsigned int page_size,
>         } else {
>                 unsigned int pack_align;
>                 unsigned int ingpad, ingpack;
> -               unsigned int pcie_cap;
>
>                 /* T5 introduced the separation of the Free List Padding and
>                  * Packing Boundaries.  Thus, we can select a smaller Padding
> @@ -7292,8 +7291,7 @@ int t4_fixup_host_params(struct adapter *adap, unsigned int page_size,
>                  * multiple of the Maximum Payload Size.
>                  */
>                 pack_align = fl_align;
> -               pcie_cap = pci_find_capability(adap->pdev, PCI_CAP_ID_EXP);
> -               if (pcie_cap) {
> +               if (pci_is_pcie(adap->pdev)) {
>                         unsigned int mps, mps_log;
>                         u16 devctl;
>
> @@ -7301,9 +7299,8 @@ int t4_fixup_host_params(struct adapter *adap, unsigned int page_size,
>                          * [bits 7:5] encodes sizes as powers of 2 starting at
>                          * 128 bytes.
>                          */
> -                       pci_read_config_word(adap->pdev,
> -                                            pcie_cap + PCI_EXP_DEVCTL,
> -                                            &devctl);
> +                       pcie_capability_read_word(adap->pdev, PCI_EXP_DEVCTL,
> +                                                 &devctl);
>                         mps_log = ((devctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5) + 7;
>                         mps = 1 << mps_log;
>                         if (mps > pack_align)
> --
> 2.17.1
>
