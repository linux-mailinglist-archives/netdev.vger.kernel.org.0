Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56069409A73
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 19:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242523AbhIMRPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 13:15:04 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:33339 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbhIMRO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 13:14:57 -0400
Received: by mail-oi1-f182.google.com with SMTP id n27so15047876oij.0;
        Mon, 13 Sep 2021 10:13:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fzdy7uiMO/mp2cx2eepiTTFDFjUW7bzqmU8yp5WNli8=;
        b=EjXpenoOrGb/T5nEcG2gskxEsgibqxIF7Fqf4odTYW48Ufic8BoSQ77VDJHeD6jwqB
         ZM4NKqLRdlKA1hcH8UEGLcnl5KiOz/uzChvDh+uIKkWX2rMwOKHPuFwdu5jKy1jKjU5d
         I/I2mk8/ZQfjo8Np2//xgTsx4rsO9H7PdlH0rk1VeEXud2mu6j2oRlu6MvD0ONqSGtCi
         qKKrruELVKCiedMUafdO6cdSrHCdACGXX7ySM92yxge9hSod581IrGB55/9k/LtdD5P8
         xw2rmC/jQE7zYWr0NDQSMnwoI0fG9aHsA01OEbJANgDTlfaDpGfu7uBqkj/VFiA0q7gy
         uO4w==
X-Gm-Message-State: AOAM533CNUxUYK1X4rbCGSAoPxulGGUO4RYZeyGuaH3aBLt4EPzzqx2Y
        R6OJZ47dycHY7zsrf6m+ogRjHGnwwX1M2to019Y=
X-Google-Smtp-Source: ABdhPJycthIMz6B2ZJJ9LWMkF61ASQ+G8HF8CDlHwMdGcFGSmIGWwcHdjibjofiU5/5KaS82SKMIQSYuhmDd9HIw8PQ=
X-Received: by 2002:a05:6808:10c1:: with SMTP id s1mr8229618ois.69.1631553220190;
 Mon, 13 Sep 2021 10:13:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210913140229.24797-1-omosnace@redhat.com>
In-Reply-To: <20210913140229.24797-1-omosnace@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 13 Sep 2021 19:13:28 +0200
Message-ID: <CAJZ5v0jv1Up0-rh-T7ZgkVkvheNG_D=oo98KZoCJR+BsYoWiBw@mail.gmail.com>
Subject: Re: [PATCH v4] lockdown,selinux: fix wrong subject in some SELinux
 lockdown checks
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-cxl@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-serial@vger.kernel.org, bpf@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 4:04 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> lockdown") added an implementation of the locked_down LSM hook to
> SELinux, with the aim to restrict which domains are allowed to perform
> operations that would breach lockdown.
>
> However, in several places the security_locked_down() hook is called in
> situations where the current task isn't doing any action that would
> directly breach lockdown, leading to SELinux checks that are basically
> bogus.
>
> To fix this, add an explicit struct cred pointer argument to
> security_lockdown() and define NULL as a special value to pass instead
> of current_cred() in such situations. LSMs that take the subject
> credentials into account can then fall back to some default or ignore
> such calls altogether. In the SELinux lockdown hook implementation, use
> SECINITSID_KERNEL in case the cred argument is NULL.
>
> Most of the callers are updated to pass current_cred() as the cred
> pointer, thus maintaining the same behavior. The following callers are
> modified to pass NULL as the cred pointer instead:
> 1. arch/powerpc/xmon/xmon.c
>      Seems to be some interactive debugging facility. It appears that
>      the lockdown hook is called from interrupt context here, so it
>      should be more appropriate to request a global lockdown decision.
> 2. fs/tracefs/inode.c:tracefs_create_file()
>      Here the call is used to prevent creating new tracefs entries when
>      the kernel is locked down. Assumes that locking down is one-way -
>      i.e. if the hook returns non-zero once, it will never return zero
>      again, thus no point in creating these files. Also, the hook is
>      often called by a module's init function when it is loaded by
>      userspace, where it doesn't make much sense to do a check against
>      the current task's creds, since the task itself doesn't actually
>      use the tracing functionality (i.e. doesn't breach lockdown), just
>      indirectly makes some new tracepoints available to whoever is
>      authorized to use them.
> 3. net/xfrm/xfrm_user.c:copy_to_user_*()
>      Here a cryptographic secret is redacted based on the value returned
>      from the hook. There are two possible actions that may lead here:
>      a) A netlink message XFRM_MSG_GETSA with NLM_F_DUMP set - here the
>         task context is relevant, since the dumped data is sent back to
>         the current task.
>      b) When adding/deleting/updating an SA via XFRM_MSG_xxxSA, the
>         dumped SA is broadcasted to tasks subscribed to XFRM events -
>         here the current task context is not relevant as it doesn't
>         represent the tasks that could potentially see the secret.
>      It doesn't seem worth it to try to keep using the current task's
>      context in the a) case, since the eventual data leak can be
>      circumvented anyway via b), plus there is no way for the task to
>      indicate that it doesn't care about the actual key value, so the
>      check could generate a lot of "false alert" denials with SELinux.
>      Thus, let's pass NULL instead of current_cred() here faute de
>      mieux.
>
> Improvements-suggested-by: Casey Schaufler <casey@schaufler-ca.com>
> Improvements-suggested-by: Paul Moore <paul@paul-moore.com>
> Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> Acked-by: Dan Williams <dan.j.williams@intel.com>         [cxl]
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com> [xfrm]
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

for the ACPI and hibernation changes.

> ---
>
> v4:
> - rebase on top of TODO
> - fix rebase conflicts:
>   * drivers/cxl/pci.c
>     - trivial: the lockdown reason was corrected in mainline
>   * kernel/bpf/helpers.c, kernel/trace/bpf_trace.c
>     - trivial: LOCKDOWN_BPF_READ was renamed to LOCKDOWN_BPF_READ_KERNEL
>       in mainline
>   * kernel/power/hibernate.c
>     - trivial: !secretmem_active() was added to the condition in
>       hibernation_available()
> - cover new security_locked_down() call in kernel/bpf/helpers.c
>   (LOCKDOWN_BPF_WRITE_USER in BPF_FUNC_probe_write_user case)
>
> v3: https://lore.kernel.org/lkml/20210616085118.1141101-1-omosnace@redhat.com/
> - add the cred argument to security_locked_down() and adapt all callers
> - keep using current_cred() in BPF, as the hook calls have been shifted
>   to program load time (commit ff40e51043af ("bpf, lockdown, audit: Fix
>   buggy SELinux lockdown permission checks"))
> - in SELinux, don't ignore hook calls where cred == NULL, but use
>   SECINITSID_KERNEL as the subject instead
> - update explanations in the commit message
>
> v2: https://lore.kernel.org/lkml/20210517092006.803332-1-omosnace@redhat.com/
> - change to a single hook based on suggestions by Casey Schaufler
>
> v1: https://lore.kernel.org/lkml/20210507114048.138933-1-omosnace@redhat.com/
>
>  arch/powerpc/xmon/xmon.c             |  4 ++--
>  arch/x86/kernel/ioport.c             |  4 ++--
>  arch/x86/kernel/msr.c                |  4 ++--
>  arch/x86/mm/testmmiotrace.c          |  2 +-
>  drivers/acpi/acpi_configfs.c         |  2 +-
>  drivers/acpi/custom_method.c         |  2 +-
>  drivers/acpi/osl.c                   |  3 ++-
>  drivers/acpi/tables.c                |  2 +-
>  drivers/char/mem.c                   |  2 +-
>  drivers/cxl/pci.c                    |  2 +-
>  drivers/firmware/efi/efi.c           |  2 +-
>  drivers/firmware/efi/test/efi_test.c |  2 +-
>  drivers/pci/pci-sysfs.c              |  6 +++---
>  drivers/pci/proc.c                   |  6 +++---
>  drivers/pci/syscall.c                |  2 +-
>  drivers/pcmcia/cistpl.c              |  2 +-
>  drivers/tty/serial/serial_core.c     |  2 +-
>  fs/debugfs/file.c                    |  2 +-
>  fs/debugfs/inode.c                   |  2 +-
>  fs/proc/kcore.c                      |  2 +-
>  fs/tracefs/inode.c                   |  2 +-
>  include/linux/lsm_hook_defs.h        |  2 +-
>  include/linux/lsm_hooks.h            |  1 +
>  include/linux/security.h             |  4 ++--
>  kernel/bpf/helpers.c                 | 10 ++++++----
>  kernel/events/core.c                 |  2 +-
>  kernel/kexec.c                       |  2 +-
>  kernel/kexec_file.c                  |  2 +-
>  kernel/module.c                      |  2 +-
>  kernel/params.c                      |  2 +-
>  kernel/power/hibernate.c             |  2 +-
>  kernel/trace/bpf_trace.c             | 25 +++++++++++++++----------
>  kernel/trace/ftrace.c                |  4 ++--
>  kernel/trace/ring_buffer.c           |  2 +-
>  kernel/trace/trace.c                 | 10 +++++-----
>  kernel/trace/trace_events.c          |  2 +-
>  kernel/trace/trace_events_hist.c     |  4 ++--
>  kernel/trace/trace_events_synth.c    |  2 +-
>  kernel/trace/trace_events_trigger.c  |  2 +-
>  kernel/trace/trace_kprobe.c          |  6 +++---
>  kernel/trace/trace_printk.c          |  2 +-
>  kernel/trace/trace_stack.c           |  2 +-
>  kernel/trace/trace_stat.c            |  2 +-
>  kernel/trace/trace_uprobe.c          |  4 ++--
>  net/xfrm/xfrm_user.c                 | 11 +++++++++--
>  security/lockdown/lockdown.c         |  3 ++-
>  security/security.c                  |  4 ++--
>  security/selinux/hooks.c             |  7 +++++--
>  48 files changed, 99 insertions(+), 79 deletions(-)
>
> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
> index dd8241c009e5..47464e873749 100644
> --- a/arch/powerpc/xmon/xmon.c
> +++ b/arch/powerpc/xmon/xmon.c
> @@ -309,7 +309,7 @@ static bool xmon_is_locked_down(void)
>         static bool lockdown;
>
>         if (!lockdown) {
> -               lockdown = !!security_locked_down(LOCKDOWN_XMON_RW);
> +               lockdown = !!security_locked_down(NULL, LOCKDOWN_XMON_RW);
>                 if (lockdown) {
>                         printf("xmon: Disabled due to kernel lockdown\n");
>                         xmon_is_ro = true;
> @@ -317,7 +317,7 @@ static bool xmon_is_locked_down(void)
>         }
>
>         if (!xmon_is_ro) {
> -               xmon_is_ro = !!security_locked_down(LOCKDOWN_XMON_WR);
> +               xmon_is_ro = !!security_locked_down(NULL, LOCKDOWN_XMON_WR);
>                 if (xmon_is_ro)
>                         printf("xmon: Read-only due to kernel lockdown\n");
>         }
> diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
> index e2fab3ceb09f..838ba45ecc71 100644
> --- a/arch/x86/kernel/ioport.c
> +++ b/arch/x86/kernel/ioport.c
> @@ -71,7 +71,7 @@ long ksys_ioperm(unsigned long from, unsigned long num, int turn_on)
>         if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
>                 return -EINVAL;
>         if (turn_on && (!capable(CAP_SYS_RAWIO) ||
> -                       security_locked_down(LOCKDOWN_IOPORT)))
> +                       security_locked_down(current_cred(), LOCKDOWN_IOPORT)))
>                 return -EPERM;
>
>         /*
> @@ -187,7 +187,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, level)
>         /* Trying to gain more privileges? */
>         if (level > old) {
>                 if (!capable(CAP_SYS_RAWIO) ||
> -                   security_locked_down(LOCKDOWN_IOPORT))
> +                   security_locked_down(current_cred(), LOCKDOWN_IOPORT))
>                         return -EPERM;
>         }
>
> diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
> index ed8ac6bcbafb..6a687d91515b 100644
> --- a/arch/x86/kernel/msr.c
> +++ b/arch/x86/kernel/msr.c
> @@ -116,7 +116,7 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
>         int err = 0;
>         ssize_t bytes = 0;
>
> -       err = security_locked_down(LOCKDOWN_MSR);
> +       err = security_locked_down(current_cred(), LOCKDOWN_MSR);
>         if (err)
>                 return err;
>
> @@ -179,7 +179,7 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
>                         err = -EFAULT;
>                         break;
>                 }
> -               err = security_locked_down(LOCKDOWN_MSR);
> +               err = security_locked_down(current_cred(), LOCKDOWN_MSR);
>                 if (err)
>                         break;
>
> diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
> index bda73cb7a044..c43a13241ae8 100644
> --- a/arch/x86/mm/testmmiotrace.c
> +++ b/arch/x86/mm/testmmiotrace.c
> @@ -116,7 +116,7 @@ static void do_test_bulk_ioremapping(void)
>  static int __init init(void)
>  {
>         unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
> -       int ret = security_locked_down(LOCKDOWN_MMIOTRACE);
> +       int ret = security_locked_down(current_cred(), LOCKDOWN_MMIOTRACE);
>
>         if (ret)
>                 return ret;
> diff --git a/drivers/acpi/acpi_configfs.c b/drivers/acpi/acpi_configfs.c
> index c970792b11a4..17c4e79b596e 100644
> --- a/drivers/acpi/acpi_configfs.c
> +++ b/drivers/acpi/acpi_configfs.c
> @@ -26,7 +26,7 @@ static ssize_t acpi_table_aml_write(struct config_item *cfg,
>  {
>         const struct acpi_table_header *header = data;
>         struct acpi_table *table;
> -       int ret = security_locked_down(LOCKDOWN_ACPI_TABLES);
> +       int ret = security_locked_down(current_cred(), LOCKDOWN_ACPI_TABLES);
>
>         if (ret)
>                 return ret;
> diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
> index d39a9b474727..8cac7f683245 100644
> --- a/drivers/acpi/custom_method.c
> +++ b/drivers/acpi/custom_method.c
> @@ -30,7 +30,7 @@ static ssize_t cm_write(struct file *file, const char __user *user_buf,
>         acpi_status status;
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_ACPI_TABLES);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_ACPI_TABLES);
>         if (ret)
>                 return ret;
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index a43f1521efe6..11c462788db8 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -198,7 +198,8 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
>          * specific location (if appropriate) so it can be carried
>          * over further kexec()s.
>          */
> -       if (acpi_rsdp && !security_locked_down(LOCKDOWN_ACPI_TABLES)) {
> +       if (acpi_rsdp && !security_locked_down(current_cred(),
> +                                              LOCKDOWN_ACPI_TABLES)) {
>                 acpi_arch_set_root_pointer(acpi_rsdp);
>                 return acpi_rsdp;
>         }
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index f9383736fa0f..6569ccacd24b 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -577,7 +577,7 @@ void __init acpi_table_upgrade(void)
>         if (table_nr == 0)
>                 return;
>
> -       if (security_locked_down(LOCKDOWN_ACPI_TABLES)) {
> +       if (security_locked_down(current_cred(), LOCKDOWN_ACPI_TABLES)) {
>                 pr_notice("kernel is locked down, ignoring table override\n");
>                 return;
>         }
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 1c596b5cdb27..330749897cd7 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -617,7 +617,7 @@ static int open_port(struct inode *inode, struct file *filp)
>         if (!capable(CAP_SYS_RAWIO))
>                 return -EPERM;
>
> -       rc = security_locked_down(LOCKDOWN_DEV_MEM);
> +       rc = security_locked_down(current_cred(), LOCKDOWN_DEV_MEM);
>         if (rc)
>                 return rc;
>
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 8e45aa07d662..539c91959234 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -575,7 +575,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
>         if (!IS_ENABLED(CONFIG_CXL_MEM_RAW_COMMANDS))
>                 return false;
>
> -       if (security_locked_down(LOCKDOWN_PCI_ACCESS))
> +       if (security_locked_down(current_cred(), LOCKDOWN_PCI_ACCESS))
>                 return false;
>
>         if (cxl_raw_allow_all)
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 847f33ffc4ae..a885b4c38358 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -200,7 +200,7 @@ static void generic_ops_unregister(void)
>  static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX] __initdata;
>  static int __init efivar_ssdt_setup(char *str)
>  {
> -       int ret = security_locked_down(LOCKDOWN_ACPI_TABLES);
> +       int ret = security_locked_down(current_cred(), LOCKDOWN_ACPI_TABLES);
>
>         if (ret)
>                 return ret;
> diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
> index 47d67bb0a516..942c25843665 100644
> --- a/drivers/firmware/efi/test/efi_test.c
> +++ b/drivers/firmware/efi/test/efi_test.c
> @@ -722,7 +722,7 @@ static long efi_test_ioctl(struct file *file, unsigned int cmd,
>
>  static int efi_test_open(struct inode *inode, struct file *file)
>  {
> -       int ret = security_locked_down(LOCKDOWN_EFI_TEST);
> +       int ret = security_locked_down(current_cred(), LOCKDOWN_EFI_TEST);
>
>         if (ret)
>                 return ret;
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 7fb5cd17cc98..b76055dbbb03 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -753,7 +753,7 @@ static ssize_t pci_write_config(struct file *filp, struct kobject *kobj,
>         u8 *data = (u8 *) buf;
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_PCI_ACCESS);
>         if (ret)
>                 return ret;
>
> @@ -1047,7 +1047,7 @@ static int pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
>         struct resource *res = &pdev->resource[bar];
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_PCI_ACCESS);
>         if (ret)
>                 return ret;
>
> @@ -1128,7 +1128,7 @@ static ssize_t pci_write_resource_io(struct file *filp, struct kobject *kobj,
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_PCI_ACCESS);
>         if (ret)
>                 return ret;
>
> diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
> index cb18f8a13ab6..1dbdcdf0eff5 100644
> --- a/drivers/pci/proc.c
> +++ b/drivers/pci/proc.c
> @@ -119,7 +119,7 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
>         int size = dev->cfg_size;
>         int cnt, ret;
>
> -       ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_PCI_ACCESS);
>         if (ret)
>                 return ret;
>
> @@ -202,7 +202,7 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
>  #endif /* HAVE_PCI_MMAP */
>         int ret = 0;
>
> -       ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_PCI_ACCESS);
>         if (ret)
>                 return ret;
>
> @@ -249,7 +249,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
>         int i, ret, write_combine = 0, res_bit = IORESOURCE_MEM;
>
>         if (!capable(CAP_SYS_RAWIO) ||
> -           security_locked_down(LOCKDOWN_PCI_ACCESS))
> +           security_locked_down(current_cred(), LOCKDOWN_PCI_ACCESS))
>                 return -EPERM;
>
>         if (fpriv->mmap_state == pci_mmap_io) {
> diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
> index 61a6fe3cde21..e88cacf8d418 100644
> --- a/drivers/pci/syscall.c
> +++ b/drivers/pci/syscall.c
> @@ -93,7 +93,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
>         int err = 0;
>
>         if (!capable(CAP_SYS_ADMIN) ||
> -           security_locked_down(LOCKDOWN_PCI_ACCESS))
> +           security_locked_down(current_cred(), LOCKDOWN_PCI_ACCESS))
>                 return -EPERM;
>
>         dev = pci_get_domain_bus_and_slot(0, bus, dfn);
> diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
> index 948b763dc451..96c96c1cd6da 100644
> --- a/drivers/pcmcia/cistpl.c
> +++ b/drivers/pcmcia/cistpl.c
> @@ -1577,7 +1577,7 @@ static ssize_t pccard_store_cis(struct file *filp, struct kobject *kobj,
>         struct pcmcia_socket *s;
>         int error;
>
> -       error = security_locked_down(LOCKDOWN_PCMCIA_CIS);
> +       error = security_locked_down(current_cred(), LOCKDOWN_PCMCIA_CIS);
>         if (error)
>                 return error;
>
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 0e2e35ab64c7..7fbec2644b1b 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -840,7 +840,7 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
>         }
>
>         if (change_irq || change_port) {
> -               retval = security_locked_down(LOCKDOWN_TIOCSSERIAL);
> +               retval = security_locked_down(current_cred(), LOCKDOWN_TIOCSSERIAL);
>                 if (retval)
>                         goto exit;
>         }
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 7d162b0efbf0..a8e44f3e11d2 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -154,7 +154,7 @@ static int debugfs_locked_down(struct inode *inode,
>             !real_fops->mmap)
>                 return 0;
>
> -       if (security_locked_down(LOCKDOWN_DEBUGFS))
> +       if (security_locked_down(current_cred(), LOCKDOWN_DEBUGFS))
>                 return -EPERM;
>
>         return 0;
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index 8129a430d789..17f6438cc1b5 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -48,7 +48,7 @@ static int debugfs_setattr(struct user_namespace *mnt_userns,
>         int ret;
>
>         if (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) {
> -               ret = security_locked_down(LOCKDOWN_DEBUGFS);
> +               ret = security_locked_down(current_cred(), LOCKDOWN_DEBUGFS);
>                 if (ret)
>                         return ret;
>         }
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index 982e694aae77..f386fd373ea6 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -586,7 +586,7 @@ out:
>
>  static int open_kcore(struct inode *inode, struct file *filp)
>  {
> -       int ret = security_locked_down(LOCKDOWN_KCORE);
> +       int ret = security_locked_down(current_cred(), LOCKDOWN_KCORE);
>
>         if (!capable(CAP_SYS_RAWIO))
>                 return -EPERM;
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 1261e8b41edb..9db8dd52d429 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -396,7 +396,7 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
>         struct dentry *dentry;
>         struct inode *inode;
>
> -       if (security_locked_down(LOCKDOWN_TRACEFS))
> +       if (security_locked_down(NULL, LOCKDOWN_TRACEFS))
>                 return NULL;
>
>         if (!(mode & S_IFMT))
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 2adeea44c0d5..a83a370cc284 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -393,7 +393,7 @@ LSM_HOOK(int, 0, bpf_prog_alloc_security, struct bpf_prog_aux *aux)
>  LSM_HOOK(void, LSM_RET_VOID, bpf_prog_free_security, struct bpf_prog_aux *aux)
>  #endif /* CONFIG_BPF_SYSCALL */
>
> -LSM_HOOK(int, 0, locked_down, enum lockdown_reason what)
> +LSM_HOOK(int, 0, locked_down, const struct cred *cred, enum lockdown_reason what)
>
>  #ifdef CONFIG_PERF_EVENTS
>  LSM_HOOK(int, 0, perf_event_open, struct perf_event_attr *attr, int type)
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 5c4c5c0602cb..8156f2dbaab7 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1543,6 +1543,7 @@
>   *     Determine whether a kernel feature that potentially enables arbitrary
>   *     code execution in kernel space should be permitted.
>   *
> + *     @cred: credential asociated with the operation, or NULL if not applicable
>   *     @what: kernel feature being accessed
>   *
>   * Security hooks for perf events
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 5b7288521300..a9001c0ed885 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -471,7 +471,7 @@ void security_inode_invalidate_secctx(struct inode *inode);
>  int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
>  int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
>  int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
> -int security_locked_down(enum lockdown_reason what);
> +int security_locked_down(const struct cred *cred, enum lockdown_reason what);
>  #else /* CONFIG_SECURITY */
>
>  static inline int call_blocking_lsm_notifier(enum lsm_event event, void *data)
> @@ -1344,7 +1344,7 @@ static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32
>  {
>         return -EOPNOTSUPP;
>  }
> -static inline int security_locked_down(enum lockdown_reason what)
> +static inline int security_locked_down(struct cred *cred, enum lockdown_reason what)
>  {
>         return 0;
>  }
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 9aabf84afd4b..61a9645f9b8f 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1424,13 +1424,15 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>         case BPF_FUNC_probe_read_user:
>                 return &bpf_probe_read_user_proto;
>         case BPF_FUNC_probe_read_kernel:
> -               return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
> -                      NULL : &bpf_probe_read_kernel_proto;
> +               if (security_locked_down(current_cred(), LOCKDOWN_BPF_READ_KERNEL) < 0)
> +                       return NULL;
> +               return &bpf_probe_read_kernel_proto;
>         case BPF_FUNC_probe_read_user_str:
>                 return &bpf_probe_read_user_str_proto;
>         case BPF_FUNC_probe_read_kernel_str:
> -               return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
> -                      NULL : &bpf_probe_read_kernel_str_proto;
> +               if (security_locked_down(current_cred(), LOCKDOWN_BPF_READ_KERNEL) < 0)
> +                       return NULL;
> +               return &bpf_probe_read_kernel_str_proto;
>         case BPF_FUNC_snprintf_btf:
>                 return &bpf_snprintf_btf_proto;
>         case BPF_FUNC_snprintf:
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 744e8726c5b2..d2836e320948 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -12017,7 +12017,7 @@ SYSCALL_DEFINE5(perf_event_open,
>
>         /* REGS_INTR can leak data, lockdown must prevent this */
>         if (attr.sample_type & PERF_SAMPLE_REGS_INTR) {
> -               err = security_locked_down(LOCKDOWN_PERF);
> +               err = security_locked_down(current_cred(), LOCKDOWN_PERF);
>                 if (err)
>                         return err;
>         }
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index b5e40f069768..f908dd7889de 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -208,7 +208,7 @@ static inline int kexec_load_check(unsigned long nr_segments,
>          * kexec can be used to circumvent module loading restrictions, so
>          * prevent loading in that case
>          */
> -       result = security_locked_down(LOCKDOWN_KEXEC);
> +       result = security_locked_down(current_cred(), LOCKDOWN_KEXEC);
>         if (result)
>                 return result;
>
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 33400ff051a8..add00b325f4f 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -204,7 +204,7 @@ kimage_validate_signature(struct kimage *image)
>                  * down.
>                  */
>                 if (!ima_appraise_signature(READING_KEXEC_IMAGE) &&
> -                   security_locked_down(LOCKDOWN_KEXEC))
> +                   security_locked_down(current_cred(), LOCKDOWN_KEXEC))
>                         return -EPERM;
>
>                 pr_debug("kernel signature verification failed (%d).\n", ret);
> diff --git a/kernel/module.c b/kernel/module.c
> index 40ec9a030eec..3cad8055d7a2 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2931,7 +2931,7 @@ static int module_sig_check(struct load_info *info, int flags)
>                 return -EKEYREJECTED;
>         }
>
> -       return security_locked_down(LOCKDOWN_MODULE_SIGNATURE);
> +       return security_locked_down(current_cred(), LOCKDOWN_MODULE_SIGNATURE);
>  }
>  #else /* !CONFIG_MODULE_SIG */
>  static int module_sig_check(struct load_info *info, int flags)
> diff --git a/kernel/params.c b/kernel/params.c
> index 8299bd764e42..619bf8ad8416 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -100,7 +100,7 @@ bool parameq(const char *a, const char *b)
>  static bool param_check_unsafe(const struct kernel_param *kp)
>  {
>         if (kp->flags & KERNEL_PARAM_FL_HWPARAM &&
> -           security_locked_down(LOCKDOWN_MODULE_PARAMETERS))
> +           security_locked_down(current_cred(), LOCKDOWN_MODULE_PARAMETERS))
>                 return false;
>
>         if (kp->flags & KERNEL_PARAM_FL_UNSAFE) {
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 559acef3fddb..2625d531ee0e 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -83,7 +83,7 @@ void hibernate_release(void)
>  bool hibernation_available(void)
>  {
>         return nohibernate == 0 &&
> -               !security_locked_down(LOCKDOWN_HIBERNATION) &&
> +               !security_locked_down(current_cred(), LOCKDOWN_HIBERNATION) &&
>                 !secretmem_active();
>  }
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 8e2eb950aa82..51bdbdf75a5c 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1066,25 +1066,30 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_get_prandom_u32:
>                 return &bpf_get_prandom_u32_proto;
>         case BPF_FUNC_probe_write_user:
> -               return security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0 ?
> -                      NULL : bpf_get_probe_write_proto();
> +               if (security_locked_down(current_cred(), LOCKDOWN_BPF_WRITE_USER) < 0)
> +                       return NULL;
> +               return bpf_get_probe_write_proto();
>         case BPF_FUNC_probe_read_user:
>                 return &bpf_probe_read_user_proto;
>         case BPF_FUNC_probe_read_kernel:
> -               return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
> -                      NULL : &bpf_probe_read_kernel_proto;
> +               if (security_locked_down(current_cred(), LOCKDOWN_BPF_READ_KERNEL) < 0)
> +                       return NULL;
> +               return &bpf_probe_read_kernel_proto;
>         case BPF_FUNC_probe_read_user_str:
>                 return &bpf_probe_read_user_str_proto;
>         case BPF_FUNC_probe_read_kernel_str:
> -               return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
> -                      NULL : &bpf_probe_read_kernel_str_proto;
> +               if (security_locked_down(current_cred(), LOCKDOWN_BPF_READ_KERNEL) < 0)
> +                       return NULL;
> +               return &bpf_probe_read_kernel_str_proto;
>  #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>         case BPF_FUNC_probe_read:
> -               return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
> -                      NULL : &bpf_probe_read_compat_proto;
> +               if (security_locked_down(current_cred(), LOCKDOWN_BPF_READ_KERNEL) < 0)
> +                       return NULL;
> +               return &bpf_probe_read_compat_proto;
>         case BPF_FUNC_probe_read_str:
> -               return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
> -                      NULL : &bpf_probe_read_compat_str_proto;
> +               if (security_locked_down(current_cred(), LOCKDOWN_BPF_READ_KERNEL) < 0)
> +                       return NULL;
> +               return &bpf_probe_read_compat_str_proto;
>  #endif
>  #ifdef CONFIG_CGROUPS
>         case BPF_FUNC_get_current_cgroup_id:
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 7efbc8aaf7f6..5c1b2681c371 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3694,7 +3694,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
>         struct ftrace_iterator *iter;
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> @@ -5822,7 +5822,7 @@ __ftrace_graph_open(struct inode *inode, struct file *file,
>         int ret;
>         struct ftrace_hash *new_hash = NULL;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index c5a3fbf19617..13669fcbd466 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -5880,7 +5880,7 @@ static __init int test_ringbuffer(void)
>         int cpu;
>         int ret = 0;
>
> -       if (security_locked_down(LOCKDOWN_TRACEFS)) {
> +       if (security_locked_down(current_cred(), LOCKDOWN_TRACEFS)) {
>                 pr_warn("Lockdown is enabled, skipping ring buffer tests\n");
>                 return 0;
>         }
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7896d30d90f7..2bac9688ff6a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -486,7 +486,7 @@ int tracing_check_open_get_tr(struct trace_array *tr)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> @@ -2071,7 +2071,7 @@ int __init register_tracer(struct tracer *type)
>                 return -1;
>         }
>
> -       if (security_locked_down(LOCKDOWN_TRACEFS)) {
> +       if (security_locked_down(current_cred(), LOCKDOWN_TRACEFS)) {
>                 pr_warn("Can not register tracer %s due to lockdown\n",
>                            type->name);
>                 return -EPERM;
> @@ -9527,7 +9527,7 @@ int tracing_init_dentry(void)
>  {
>         struct trace_array *tr = &global_trace;
>
> -       if (security_locked_down(LOCKDOWN_TRACEFS)) {
> +       if (security_locked_down(current_cred(), LOCKDOWN_TRACEFS)) {
>                 pr_warn("Tracing disabled due to lockdown\n");
>                 return -EPERM;
>         }
> @@ -9989,7 +9989,7 @@ __init static int tracer_alloc_buffers(void)
>         int ret = -ENOMEM;
>
>
> -       if (security_locked_down(LOCKDOWN_TRACEFS)) {
> +       if (security_locked_down(current_cred(), LOCKDOWN_TRACEFS)) {
>                 pr_warn("Tracing disabled due to lockdown\n");
>                 return -EPERM;
>         }
> @@ -10155,7 +10155,7 @@ __init static void tracing_set_default_clock(void)
>  {
>         /* sched_clock_stable() is determined in late_initcall */
>         if (!trace_boot_clock && !sched_clock_stable()) {
> -               if (security_locked_down(LOCKDOWN_TRACEFS)) {
> +               if (security_locked_down(current_cred(), LOCKDOWN_TRACEFS)) {
>                         pr_warn("Can not set tracing clock due to lockdown\n");
>                         return;
>                 }
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 830b3b9940f4..c1e4f7f93c0e 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2130,7 +2130,7 @@ ftrace_event_open(struct inode *inode, struct file *file,
>         struct seq_file *m;
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index a6061a69aa84..e122f0467421 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -4917,7 +4917,7 @@ static int event_hist_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> @@ -5189,7 +5189,7 @@ static int event_hist_debug_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
> index d54094b7a9d7..deac45f00f3a 100644
> --- a/kernel/trace/trace_events_synth.c
> +++ b/kernel/trace/trace_events_synth.c
> @@ -2174,7 +2174,7 @@ static int synth_events_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index 3d5c07239a2a..38226c386f82 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -190,7 +190,7 @@ static int event_trigger_regex_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 3a64ba4bbad6..9178ad52290e 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -479,7 +479,7 @@ static int __register_trace_kprobe(struct trace_kprobe *tk)
>  {
>         int i, ret;
>
> -       ret = security_locked_down(LOCKDOWN_KPROBES);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_KPROBES);
>         if (ret)
>                 return ret;
>
> @@ -1141,7 +1141,7 @@ static int probes_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> @@ -1199,7 +1199,7 @@ static int profile_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
> index 4b320fe7df70..47c808484cb2 100644
> --- a/kernel/trace/trace_printk.c
> +++ b/kernel/trace/trace_printk.c
> @@ -362,7 +362,7 @@ ftrace_formats_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
> index 63c285042051..63b6ebe7bdce 100644
> --- a/kernel/trace/trace_stack.c
> +++ b/kernel/trace/trace_stack.c
> @@ -477,7 +477,7 @@ static int stack_trace_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> index 8d141c3825a9..2f6ae81ee67e 100644
> --- a/kernel/trace/trace_stat.c
> +++ b/kernel/trace/trace_stat.c
> @@ -236,7 +236,7 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
>         struct seq_file *m;
>         struct stat_session *session = inode->i_private;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 225ce569bf8f..4b114e4fe436 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -781,7 +781,7 @@ static int probes_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> @@ -836,7 +836,7 @@ static int profile_open(struct inode *inode, struct file *file)
>  {
>         int ret;
>
> -       ret = security_locked_down(LOCKDOWN_TRACEFS);
> +       ret = security_locked_down(current_cred(), LOCKDOWN_TRACEFS);
>         if (ret)
>                 return ret;
>
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index 03b66d154b2b..ffd560514d8f 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -850,8 +850,15 @@ static int copy_user_offload(struct xfrm_state_offload *xso, struct sk_buff *skb
>
>  static bool xfrm_redact(void)
>  {
> -       return IS_ENABLED(CONFIG_SECURITY) &&
> -               security_locked_down(LOCKDOWN_XFRM_SECRET);
> +       /* Don't use current_cred() here, since this may be called when
> +        * broadcasting a notification that an SA has been created/deleted.
> +        * In that case current task is the one triggering the notification,
> +        * but the SA key is actually leaked to the event subscribers.
> +        * Since we can't easily do the redact decision per-subscriber,
> +        * just pass NULL here, indicating to the LSMs that a global lockdown
> +        * decision should be made instead.
> +        */
> +       return security_locked_down(NULL, LOCKDOWN_XFRM_SECRET);
>  }
>
>  static int copy_to_user_auth(struct xfrm_algo_auth *auth, struct sk_buff *skb)
> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
> index 87cbdc64d272..2abe92157e82 100644
> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -55,7 +55,8 @@ early_param("lockdown", lockdown_param);
>   * lockdown_is_locked_down - Find out if the kernel is locked down
>   * @what: Tag to use in notice generated if lockdown is in effect
>   */
> -static int lockdown_is_locked_down(enum lockdown_reason what)
> +static int lockdown_is_locked_down(const struct cred *cred,
> +                                  enum lockdown_reason what)
>  {
>         if (WARN(what >= LOCKDOWN_CONFIDENTIALITY_MAX,
>                  "Invalid lockdown reason"))
> diff --git a/security/security.c b/security/security.c
> index 9ffa9e9c5c55..51245e37b351 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2593,9 +2593,9 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
>  }
>  #endif /* CONFIG_BPF_SYSCALL */
>
> -int security_locked_down(enum lockdown_reason what)
> +int security_locked_down(const struct cred *cred, enum lockdown_reason what)
>  {
> -       return call_int_hook(locked_down, 0, what);
> +       return call_int_hook(locked_down, 0, cred, what);
>  }
>  EXPORT_SYMBOL(security_locked_down);
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6517f221d52c..300bc9e1ffbf 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -7013,10 +7013,10 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
>  }
>  #endif
>
> -static int selinux_lockdown(enum lockdown_reason what)
> +static int selinux_lockdown(const struct cred *cred, enum lockdown_reason what)
>  {
>         struct common_audit_data ad;
> -       u32 sid = current_sid();
> +       u32 sid;
>         int invalid_reason = (what <= LOCKDOWN_NONE) ||
>                              (what == LOCKDOWN_INTEGRITY_MAX) ||
>                              (what >= LOCKDOWN_CONFIDENTIALITY_MAX);
> @@ -7028,6 +7028,9 @@ static int selinux_lockdown(enum lockdown_reason what)
>                 return -EINVAL;
>         }
>
> +       /* Use SECINITSID_KERNEL if there is no relevant cred to check against */
> +       sid = cred ? cred_sid(cred) : SECINITSID_KERNEL;
> +
>         ad.type = LSM_AUDIT_DATA_LOCKDOWN;
>         ad.u.reason = what;
>
> --
> 2.31.1
>
