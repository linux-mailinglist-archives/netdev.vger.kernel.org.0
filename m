Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD87F2956E0
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 05:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895495AbgJVDkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 23:40:06 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:53818 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895478AbgJVDkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 23:40:06 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 23:40:03 EDT
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 47DF121C25;
        Thu, 22 Oct 2020 03:31:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo06-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo06-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dB7yhJu87cFG; Thu, 22 Oct 2020 03:31:19 +0000 (UTC)
Received: from localhost.localdomain (d108-172-23-187.bchsia.telus.net [108.172.23.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailout.easymail.ca (Postfix) with ESMTPSA id B484921C11;
        Thu, 22 Oct 2020 03:30:55 +0000 (UTC)
From:   Rhys Rustad-Elliott <me@rhysre.net>
Cc:     me@rhysre.net, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] Docs/bpf: Improve bpf_design_QA.rst
Date:   Wed, 21 Oct 2020 20:29:12 -0700
Message-Id: <20201022032912.18535-1-me@rhysre.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Rephrase wording such that the file flows better
- Improve consistency with respect to word use, grammar and style
- Remove point on loops not being supported as BPF now has support for
  bounded loops

Signed-off-by: Rhys Rustad-Elliott <me@rhysre.net>
---
 Documentation/bpf/bpf_design_QA.rst | 382 +++++++++++++---------------
 1 file changed, 183 insertions(+), 199 deletions(-)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 2df7b067ab93..fe9087144d75 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -1,254 +1,238 @@
 ==============
 BPF Design Q&A
 ==============
-
-BPF extensibility and applicability to networking, tracing, security
-in the linux kernel and several user space implementations of BPF
-virtual machine led to a number of misunderstanding on what BPF actually is.
-This short QA is an attempt to address that and outline a direction
-of where BPF is heading long term.
+The extensibility of BPF and its wide applicability (eg. to networking, tracing
+and security), as well as the existence of several userspace implementations of
+the BPF virtual machine have led to a number of misunderstandings regarding what
+BPF actually is. This short Q&A is an attempt to address those misunderstandings
+as well as outline where BPF is heading in the long term.
 
 .. contents::
     :local:
-    :depth: 3
-
-Questions and Answers
-=====================
+    :depth: 2
 
-Q: Is BPF a generic instruction set similar to x64 and arm64?
--------------------------------------------------------------
+Q: Is BPF a generic instruction set similar to x86-64 and arm64?
+----------------------------------------------------------------
 A: NO.
 
-Q: Is BPF a generic virtual machine ?
+Q: Is BPF a generic virtual machine?
 -------------------------------------
 A: NO.
 
-BPF is generic instruction set *with* C calling convention.
------------------------------------------------------------
+Q: Then what is BPF?
+--------------------
+A: BPF is a generic instruction set *with* C calling conventions.
 
-Q: Why C calling convention was chosen?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-A: Because BPF programs are designed to run in the linux kernel
-which is written in C, hence BPF defines instruction set compatible
-with two most used architectures x64 and arm64 (and takes into
-consideration important quirks of other architectures) and
-defines calling convention that is compatible with C calling
-convention of the linux kernel on those architectures.
+Q: Why were C calling conventions chosen?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+A: BPF programs are designed to run in the Linux kernel which is written in C;
+hence BPF defines an instruction set compatible with the two most used
+architectures, x86-64 and arm64 (while taking into consideration important
+quirks of other architectures) and uses calling conventions that are compatible
+with the C calling conventions of the Linux kernel on those architectures.
 
 Q: Can multiple return values be supported in the future?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-A: NO. BPF allows only register R0 to be used as return value.
+A: NO. BPF allows only register R0 to be used as a return value.
 
-Q: Can more than 5 function arguments be supported in the future?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-A: NO. BPF calling convention only allows registers R1-R5 to be used
-as arguments. BPF is not a standalone instruction set.
-(unlike x64 ISA that allows msft, cdecl and other conventions)
+Q: Can more than five function arguments be supported in the future?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+A: NO. The BPF calling convention only allows registers R1-R5 to be used as
+arguments. BPF is not a standalone instruction set. This is unlike, for example,
+the x86-64 ISA, which allows msft, cdecl and other calling conventions.
 
-Q: Can BPF programs access instruction pointer or return address?
------------------------------------------------------------------
+Q: Can BPF programs access the instruction pointer or return addresses?
+-----------------------------------------------------------------------
 A: NO.
 
-Q: Can BPF programs access stack pointer ?
-------------------------------------------
+Q: Can BPF programs access the stack pointer?
+---------------------------------------------
 A: NO.
 
-Only frame pointer (register R10) is accessible.
-From compiler point of view it's necessary to have stack pointer.
-For example, LLVM defines register R11 as stack pointer in its
-BPF backend, but it makes sure that generated code never uses it.
+Only the frame pointer (register R10) is accessible.
 
-Q: Does C-calling convention diminishes possible use cases?
------------------------------------------------------------
+Note that from the compiler's point of view, it is necessary to have a stack
+pointer. For example, LLVM defines register R11 as the stack pointer in its BPF
+backend, but makes sure that the generated code never uses it.
+
+Q: Does the use of C calling conventions diminish possible use cases?
+---------------------------------------------------------------------
 A: YES.
 
-BPF design forces addition of major functionality in the form
-of kernel helper functions and kernel objects like BPF maps with
-seamless interoperability between them. It lets kernel call into
-BPF programs and programs call kernel helpers with zero overhead,
-as all of them were native C code. That is particularly the case
-for JITed BPF programs that are indistinguishable from
-native kernel C code.
+The design of BPF forces the addition of major functionality in the form of
+kernel helper functions and kernel objects, such as BPF maps (with seamless
+interoperability between them). It lets the kernel call into BPF programs and
+BPF programs call helper functions with zero overhead, as if all of them were
+native C code. This is particularly evident for JITed BPF programs, which are
+indistinguishable from native kernel C code.
 
-Q: Does it mean that 'innovative' extensions to BPF code are disallowed?
-------------------------------------------------------------------------
+Q: Does this mean that "innovative" extensions to BPF code are disallowed?
+--------------------------------------------------------------------------
 A: Soft yes.
 
-At least for now, until BPF core has support for
-bpf-to-bpf calls, indirect calls, loops, global variables,
-jump tables, read-only sections, and all other normal constructs
-that C code can produce.
-
-Q: Can loops be supported in a safe way?
-----------------------------------------
-A: It's not clear yet.
-
-BPF developers are trying to find a way to
-support bounded loops.
+At least for now, until the BPF core has support for BPF-to-BPF calls, indirect
+calls, global variables, jump tables, read-only sections and all other normal
+constructs that C code can produce.
 
 Q: What are the verifier limits?
 --------------------------------
-A: The only limit known to the user space is BPF_MAXINSNS (4096).
-It's the maximum number of instructions that the unprivileged bpf
-program can have. The verifier has various internal limits.
-Like the maximum number of instructions that can be explored during
-program analysis. Currently, that limit is set to 1 million.
-Which essentially means that the largest program can consist
-of 1 million NOP instructions. There is a limit to the maximum number
-of subsequent branches, a limit to the number of nested bpf-to-bpf
-calls, a limit to the number of the verifier states per instruction,
-a limit to the number of maps used by the program.
-All these limits can be hit with a sufficiently complex program.
-There are also non-numerical limits that can cause the program
-to be rejected. The verifier used to recognize only pointer + constant
-expressions. Now it can recognize pointer + bounded_register.
-bpf_lookup_map_elem(key) had a requirement that 'key' must be
-a pointer to the stack. Now, 'key' can be a pointer to map value.
-The verifier is steadily getting 'smarter'. The limits are
-being removed. The only way to know that the program is going to
-be accepted by the verifier is to try to load it.
-The bpf development process guarantees that the future kernel
-versions will accept all bpf programs that were accepted by
-the earlier versions.
-
-
-Instruction level questions
----------------------------
-
-Q: LD_ABS and LD_IND instructions vs C code
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-Q: How come LD_ABS and LD_IND instruction are present in BPF whereas
-C code cannot express them and has to use builtin intrinsics?
-
-A: This is artifact of compatibility with classic BPF. Modern
-networking code in BPF performs better without them.
-See 'direct packet access'.
-
-Q: BPF instructions mapping not one-to-one to native CPU
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Q: It seems not all BPF instructions are one-to-one to native CPU.
-For example why BPF_JNE and other compare and jumps are not cpu-like?
-
-A: This was necessary to avoid introducing flags into ISA which are
-impossible to make generic and efficient across CPU architectures.
-
-Q: Why BPF_DIV instruction doesn't map to x64 div?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-A: Because if we picked one-to-one relationship to x64 it would have made
-it more complicated to support on arm64 and other archs. Also it
-needs div-by-zero runtime check.
-
-Q: Why there is no BPF_SDIV for signed divide operation?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-A: Because it would be rarely used. llvm errors in such case and
-prints a suggestion to use unsigned divide instead.
-
-Q: Why BPF has implicit prologue and epilogue?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-A: Because architectures like sparc have register windows and in general
-there are enough subtle differences between architectures, so naive
-store return address into stack won't work. Another reason is BPF has
-to be safe from division by zero (and legacy exception path
-of LD_ABS insn). Those instructions need to invoke epilogue and
-return implicitly.
-
-Q: Why BPF_JLT and BPF_JLE instructions were not introduced in the beginning?
+A: The only limit exposed to userspace is ``BPF_MAXINSNS`` (4096). This is the
+maximum number of instructions that an unprivileged BPF program can consist of.
+
+The verifier has various internal limits, such as the maximum number of
+instructions that can be explored during program analysis. Currently, that limit
+is set to one million, which essentially means that the largest possible BPF
+program consists of one million NOP instructions. There is additionally a limit
+on the maximum number of subsequent branches, a limit on the number of nested
+BPF-to-BPF calls, a limit on the number of verifier states per instruction, and
+a limit on the number of maps used by the program. All these limits can be hit
+given a sufficiently complex program.
+
+There are also non-numerical limits that can cause the program to be rejected.
+The verifier used to recognize only pointer + constant expressions. Now it can
+recognize pointer + bounded_register. ``bpf_lookup_map_elem(key)`` had a
+requirement that ``key`` must be a pointer to the stack. Now, ``key`` can be a
+pointer to a map value.
+
+The verifier is steadily getting smarter and limits are being removed. As such,
+the only way to know that a program is going to be accepted by the verifier is
+to try to load it. The BPF development process guarantees that future kernel
+versions will accept all BPF programs that were accepted by earlier versions.
+
+
+Questions Regarding BPF Instructions
+------------------------------------
+
+Q: Why do the LD_ABS and LD_IND instructions exist given there's a C equivalent?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Q: How come the LD_ABS and LD_IND instructions are present in BPF given C code
+cannot express them and has to use builtin intrinsics?
+
+A: This is an artifact of compatibility with classic BPF. Modern networking code
+in BPF performs better without them. See "direct packet access".
+
+Q: Why do some BPF instructions not map one-to-one with hardware instructions?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Q: It seems not all BPF instructions map one-to-one with native CPU
+instructions. For example why are BPF_JNE and other compares and jumps not
+CPU-like?
+
+A: This was necessary to avoid introducing flags into the ISA which are
+impossible to make generic and efficient across different CPU architectures.
+
+Q: Why does the BPF_DIV instruction not map to the x86-64 div?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+A: Because if a one-to-one relationship with x86-64 was picked, it would have
+been more complicated to support on arm64 and other architectures. Additionally,
+it would require a divide-by-zero runtime check.
+
+Q: Why there is no BPF_SDIV for a signed divide operation?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+A: Because it would be rarely used. LLVM produces an error in such cases and
+prints a suggestion to use an unsigned divide instead.
+
+Q: Why do BPF programs have an implicit prologue and epilogue?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+A: Because some architectures (eg. SPARC) have register windows. There are
+additionally enough other subtle differences between architectures such that
+that a naive store of the return address into the stack won't work.
+
+Another reason is that BPF has to be safe from division by zero errors (and the
+legacy exception path of the LD_ABS instruction). Those instructions need to
+invoke the epilogue and return implicitly.
+
+Q: Why were BPF_JLT and BPF_JLE instructions not introduced in the beginning?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-A: Because classic BPF didn't have them and BPF authors felt that compiler
-workaround would be acceptable. Turned out that programs lose performance
-due to lack of these compare instructions and they were added.
-These two instructions is a perfect example what kind of new BPF
-instructions are acceptable and can be added in the future.
-These two already had equivalent instructions in native CPUs.
-New instructions that don't have one-to-one mapping to HW instructions
-will not be accepted.
-
-Q: BPF 32-bit subregister requirements
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Q: BPF 32-bit subregisters have a requirement to zero upper 32-bits of BPF
-registers which makes BPF inefficient virtual machine for 32-bit
-CPU architectures and 32-bit HW accelerators. Can true 32-bit registers
-be added to BPF in the future?
+A: Because classic BPF didn't have them and the BPF authors felt that a compiler
+workaround would be acceptable. As it turned out, programs lost performance due
+to the lack of these compare instructions. As such, they were later added.
+
+These two instructions are perfect examples of what kind of new BPF instructions
+are acceptable and can be added in the future as they both already had
+equivalent hardware instructions. New instructions that don't have a one-to-one
+mapping to hardware instructions will not be accepted.
+
+Q: Can we improve the performance of BPF's 32-bit subregisters?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Q: BPF's 32-bit subregisters require the zeroing of the upper 32 bits when used.
+This makes BPF inefficient for 32-bit CPU architectures and 32-bit hardware
+accelerators. Can true 32-bit registers be added to BPF in the future?
 
 A: NO.
 
-But some optimizations on zero-ing the upper 32 bits for BPF registers are
-available, and can be leveraged to improve the performance of JITed BPF
-programs for 32-bit architectures.
-
-Starting with version 7, LLVM is able to generate instructions that operate
-on 32-bit subregisters, provided the option -mattr=+alu32 is passed for
-compiling a program. Furthermore, the verifier can now mark the
-instructions for which zero-ing the upper bits of the destination register
-is required, and insert an explicit zero-extension (zext) instruction
-(a mov32 variant). This means that for architectures without zext hardware
-support, the JIT back-ends do not need to clear the upper bits for
-subregisters written by alu32 instructions or narrow loads. Instead, the
-back-ends simply need to support code generation for that mov32 variant,
-and to overwrite bpf_jit_needs_zext() to make it return "true" (in order to
-enable zext insertion in the verifier).
-
-Note that it is possible for a JIT back-end to have partial hardware
-support for zext. In that case, if verifier zext insertion is enabled,
-it could lead to the insertion of unnecessary zext instructions. Such
-instructions could be removed by creating a simple peephole inside the JIT
-back-end: if one instruction has hardware support for zext and if the next
-instruction is an explicit zext, then the latter can be skipped when doing
-the code generation.
+However some optimizations pertaining to the zeroing of the upper 32 bits of BPF
+registers are available and can be leveraged to improve the performance of JITed
+BPF programs for 32-bit architectures.
+
+Starting with version 7, LLVM is able to generate instructions that operate on
+32-bit subregisters, provided the option ``-mattr=+alu32`` is passed for
+compiling a program. Furthermore, the verifier can now mark the instructions for
+which zeroing the upper bits of the destination register is required, and insert
+an explicit zero-extension (zext) instruction (a mov32 variant). This means that
+for architectures without zext hardware support, the JIT backends do not need to
+clear the upper bits for subregisters written by alu32 instructions or narrow
+loads. Instead, the backends simply need to support code generation for that
+mov32 variant, and to overwrite ``bpf_jit_needs_zext()`` to make it return true
+(in order to enable zext insertion in the verifier).
+
+Note that it is possible for a JIT backend to have partial hardware support for
+zext. In that case, if verifier zext insertion is enabled, it could lead to the
+insertion of unnecessary zext instructions. Such instructions could be removed
+by creating a simple peephole inside the JIT backend: if one instruction has
+hardware support for zext and if the next instruction is an explicit zext, then
+the latter can be skipped when performing code generation.
 
 Q: Does BPF have a stable ABI?
 ------------------------------
-A: YES. BPF instructions, arguments to BPF programs, set of helper
-functions and their arguments, recognized return codes are all part
-of ABI. However there is one specific exception to tracing programs
-which are using helpers like bpf_probe_read() to walk kernel internal
-data structures and compile with kernel internal headers. Both of these
-kernel internals are subject to change and can break with newer kernels
-such that the program needs to be adapted accordingly.
-
-Q: How much stack space a BPF program uses?
--------------------------------------------
-A: Currently all program types are limited to 512 bytes of stack
-space, but the verifier computes the actual amount of stack used
-and both interpreter and most JITed code consume necessary amount.
-
-Q: Can BPF be offloaded to HW?
-------------------------------
-A: YES. BPF HW offload is supported by NFP driver.
-
-Q: Does classic BPF interpreter still exist?
---------------------------------------------
+A: YES. BPF instructions, arguments to BPF programs, the set of helper
+functions, their arguments and recognized return codes are all part of the ABI
+and are stable.
+
+There is however one specific exception pertaining to tracing programs which use
+helpers like ``bpf_probe_read()`` to walk internal kernel data structures and
+compile with internal kernel headers. These kernel internals are subject to
+change. As such, these types of programs need to be adapted accordingly.
+
+Q: How much stack space can a BPF program use?
+----------------------------------------------
+A: Currently all program types are limited to 512 bytes of stack space. The
+verifier computes the actual amount of stack space used such that interpreted
+code never goes over the limit and most JITed code never goes over the limit.
+
+Q: Can BPF be offloaded to hardware.
+------------------------------------
+A: YES. BPF hardware offload is supported by the NFP driver.
+
+Q: Does the classic BPF interpreter still exist?
+------------------------------------------------
 A: NO. Classic BPF programs are converted into extend BPF instructions.
 
 Q: Can BPF call arbitrary kernel functions?
 -------------------------------------------
-A: NO. BPF programs can only call a set of helper functions which
-is defined for every program type.
+A: NO. BPF programs can only call a set of helper functions which are defined
+per program type.
 
 Q: Can BPF overwrite arbitrary kernel memory?
 ---------------------------------------------
 A: NO.
 
-Tracing bpf programs can *read* arbitrary memory with bpf_probe_read()
-and bpf_probe_read_str() helpers. Networking programs cannot read
-arbitrary memory, since they don't have access to these helpers.
-Programs can never read or write arbitrary memory directly.
+Tracing BPF programs can *read* arbitrary memory with ``bpf_probe_read()`` and
+``bpf_probe_read_str()`` helpers. Networking programs cannot read arbitrary
+memory, since they don't have access to these helpers. Programs can never read
+or write arbitrary memory directly.
 
 Q: Can BPF overwrite arbitrary user memory?
 -------------------------------------------
 A: Sort-of.
 
-Tracing BPF programs can overwrite the user memory
-of the current task with bpf_probe_write_user(). Every time such
-program is loaded the kernel will print warning message, so
-this helper is only useful for experiments and prototypes.
-Tracing BPF programs are root only.
+Tracing BPF programs can overwrite userspace memory of the current task with
+``bpf_probe_write_user()``. Every time such a program is loaded, the kernel will
+print a warning message, meaning this helper is really only useful for
+experiments and prototypes. Tracing BPF programs are root only.
 
-Q: New functionality via kernel modules?
-----------------------------------------
-Q: Can BPF functionality such as new program or map types, new
-helpers, etc be added out of kernel module code?
+Q: Can we add new functionality via kernel modules
+--------------------------------------------------
+Q: Can BPF functionality such as new program or map types, new helpers, etc. be
+added through the use of kernel modules?
 
 A: NO.
-- 
2.20.1

